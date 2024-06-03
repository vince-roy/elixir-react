defmodule AcmeWeb.AppController do
  use AcmeWeb, :controller

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
    conn
    |> add_default_meta
    |> add_default_headers
    |> add_host
    |> render(:index)
  end

  def use_ssr? do
    Application.get_env(:acme, :ssr) || false
  end
end
