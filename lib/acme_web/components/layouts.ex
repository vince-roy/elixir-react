defmodule AcmeWeb.Layouts do
  @moduledoc """
  This module holds different layouts used by your application.

  See the `layouts` directory for all templates available.
  The "root" layout is a skeleton rendered as part of the
  application router. The "app" layout is set as the default
  layout on both `use AcmeWeb, :controller` and
  `use AcmeWeb, :live_view`.
  """
  use AcmeWeb, :html

  embed_templates "layouts/*"

  def cdn_url do
    Application.get_env(:acme, AcmeWeb.Endpoint)[:cdn_url]
  end

  def is_prod do
    Application.get_env(:acme, :env) === :prod
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
      File.read(Path.join(:code.priv_dir(:acme), "static/public/client/manifest.json"))
      |> case do
        {:ok, file} ->
          file
          |> Jason.decode!()
          |> case do
            %{"src/entry-client.ts" => %{"file" => file}} ->
              [Path.join([cdn_url(), "/public/client/", file])]

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
                Path.join([cdn_url(), "/public/client/", file])
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
