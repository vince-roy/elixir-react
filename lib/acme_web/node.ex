defmodule AcmeWeb.Node do
  defmodule SSR do
    @enforce_keys [:headers, :url]
    defstruct [:headers, :url]
  end

  defp ssr_node(%SSR{} = args) do
    NodeJS.call(
      {"ssr.mjs", :run},
      [
        Map.from_struct(args)
      ],
      esm: true
    )
  end

  defp ssr_vite(%SSR{} = args) do
    url =
      %{
        URI.parse(args.url)
        | authority: "localhost:5173",
          port: 5173,
          host: "localhost",
          scheme: "http"
      }
      |> to_string

    Req.request(
      method: "GET",
      url: url,
      headers:
        [
          {"content-type", "application/json"}
        ] ++ Enum.into(args.headers, [])
    )
    |> case do
      {:ok, %Req.Response{body: %{"html" => _} = body}} -> {:ok, body}
      err -> err
    end
  end

  def ssr(%SSR{} = args) do
    if Application.get_env(:acme, :use_vite_server) do
      ssr_vite(args)
    else
      ssr_node(args)
    end
  end
end
