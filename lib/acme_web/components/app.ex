defmodule AcmeWeb.App do
  use Phoenix.Component

  def head(assigns) do
    ~H"""
    <script :if={Application.get_env(:acme, :use_vite_server)} type="module">
      import RefreshRuntime from "http://localhost:5173/@react-refresh"
      RefreshRuntime.injectIntoGlobalHook(window)
      window.$RefreshReg$ = () => {}
      window.$RefreshSig$ = () => (type) => type
      window.__vite_plugin_react_preamble_installed__ = true
    </script>
    <script
      :if={Application.get_env(:acme, :use_vite_server)}
      type="module"
      src="http://localhost:5173/@vite/client"
    >
    </script>
    """
  end

  def metas do
    []
  end

  def scripts do
    if Application.get_env(:acme, :use_vite_server) do
      [
        "http://localhost:5173/src/entry-client.tsx"
      ]
    else
      File.read(Path.join(:code.priv_dir(:acme), "static/public/client/.vite/manifest.json"))
      |> case do
        {:ok, file} ->
          file
          |> Jason.decode!()
          |> case do
            %{"src/entry-client.ts" => %{"file" => file}} ->
              [Path.join([AcmeWeb.cdn_url(), "/public/client/", file])]

            _ ->
              []
          end

        {:error, _} ->
          []
      end
    end
  end

  @spec stylesheets() :: list()
  def stylesheets do
    if Application.get_env(:acme, :use_vite_server) do
      []
    else
      File.read(Path.join(:code.priv_dir(:acme), "static/public/client/manifest.json"))
      |> case do
        {:ok, file} ->
          file
          |> Jason.decode!()
          |> case do
            %{"src/entry-client.ts" => %{"css" => css}} ->
              Enum.map(css, fn file ->
                Path.join([AcmeWeb.cdn_url(), "/public/client/", file])
              end)

            _ ->
              []
          end

        {:error, _} ->
          []
      end
    end
  end
end
