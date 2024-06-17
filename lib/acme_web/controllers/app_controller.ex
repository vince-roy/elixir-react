defmodule AcmeWeb.AppController do
  use AcmeWeb, :controller
  alias AcmeWeb.Node

  def add_default_meta(conn) do
    conn
    |> assign(:title, "Elixir + React + Vite Demo | Acme")
    |> assign(
      :meta_desc,
      "A demo application with Elixir, Vite and React with optional SSR"
    )
  end

  def add_default_headers(conn) do
    put_resp_header(
      conn,
      "cache-control",
      "no-store, max-age=0"
    )
    |> put_resp_header(
      "vary",
      "*"
    )
  end

  def add_host(conn) do
    host =
      Plug.Conn.request_url(conn)
      |> URI.parse()
      |> Map.get(:host)

    conn
    |> assign(:host, host)
  end

  def index(conn, _params) do
    Node.ssr(%Node.SSR{
      headers: %{},
      url: Plug.Conn.request_url(conn)
    })
    |> case do
      {:ok, %{"html" => html} = response} ->
        conn
        |> add_default_headers
        |> add_host
        |> render(
          :ssr,
          body: html,
          data: nil,
          head: response["head"]
        )

      {:error, msg} ->
        # credo:disable-for-next-line
        IO.inspect(msg)

        conn
        |> send_resp(500, "Error")
    end
  end
end
