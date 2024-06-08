defmodule AcmeWeb.ExpoController do
  use AcmeWeb, :controller

  def add_default_meta(conn) do
    conn
    |> assign(:title, "Elixir + Expo | Acme")
    |> assign(
      :meta_desc,
      "A demo application with Elixir and Expo"
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
    conn
    |> add_default_headers
    |> add_host
    |> put_root_layout({AcmeWeb.Layouts, :expo})
    |> IO.inspect()
    |> render(:index, layout: false)
  end
end
