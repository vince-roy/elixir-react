create_manifest = fn
  paths ->
    root =
      Enum.find(paths, fn path ->
        String.contains?(path, "/entry-")
      end)
      |> String.split("/priv/static/public")
      |> List.last()

    File.write(
      "./priv/static/public/expo/manifest.json",
      Jason.encode!(%{
        root: root
      })
    )
end

add_cdn_link =
  fn paths ->
    Enum.map(paths, fn path ->
      if File.dir?(path) or Path.extname(path) !== ".js" do
        nil
      else
        File.read!(path)
        |> String.replace("/assets/", System.fetch_env!("CDN_URL") <> "/assets/")
        |> String.replace("/_expo/", System.fetch_env!("CDN_URL") <> "/_expo/")
        |> then(fn content ->
          File.write!(path, content)
        end)
      end
    end)
  end

with {_, 0} <-
       System.cmd("npm", ["run", "--prefix", "client/expo", "build:web"], into: IO.stream()),
     _ <- File.rm_rf("./priv/static/public/expo"),
     :ok <- File.mkdir_p("./priv/static/public/expo"),
     {:ok, files} <- File.cp_r("./client/expo/dist", "./priv/static/public/expo"),
     _ <- {add_cdn_link.(files), create_manifest.(files)} do
  IO.puts("Expo build successful")
else
  err ->
    IO.inspect(err)
end
