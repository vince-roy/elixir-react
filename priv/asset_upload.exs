alias ExAws.S3

Mix.install([
  {:ex_aws_s3, "~> 2.3"},
  {:hackney, "~> 1.18"},
  {:jason, "~> 1.2"}
])

paths =
  to_string("./priv")
  |> Path.join("static/public/assets")
  |> File.ls!()
  |> Enum.map(fn p ->
    {
      to_string("./priv")
      |> Path.join("static/public/assets")
      |> Path.join(p),
      Path.join(
        "public/assets/",
        p
      )
    }
  end)

upload_file = fn {src_path, dest_path} ->
  S3.put_object(
    System.fetch_env!("S3_BUCKET"),
    dest_path,
    File.read!(src_path),
    acl: "public-read",
    content_type:
      cond do
        String.ends_with?(src_path, "css") ->
          "text/css"

        String.ends_with?(src_path, "js") ->
          "application/javascript"

        String.ends_with?(src_path, "ttf") ->
          "font/ttf"

        String.ends_with?(src_path, "woff") ->
          "font/woff"

        String.ends_with?(src_path, "woff2") ->
          "font/woff2"

        true ->
          "application/octet-stream"
      end
  )
  |> ExAws.request!(
    host: System.fetch_env!("S3_HOST"),
    region: System.fetch_env!("S3_REGION")
  )
end

paths
|> Task.async_stream(upload_file, max_concurrency: 10)
|> Stream.run()
