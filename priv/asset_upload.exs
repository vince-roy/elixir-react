alias ExAws.S3

Mix.install([
  {:ex_aws_s3, "~> 2.3"},
  {:hackney, "~> 1.18"},
  {:jason, "~> 1.2"}
])

# config :ex_aws,
#   access_key_id: [{:system, "AWS_ACCESS_KEY_ID"}, :instance_role],
#   secret_access_key: [{:system, "AWS_SECRET_ACCESS_KEY"}, :instance_role]

paths =
  Path.wildcard("./priv/static/public/**/*")
  |> Enum.filter(&(not File.dir?(&1)))
  |> Enum.map(fn p ->
    {
      p,
      String.replace_prefix(p, "priv/static/public/", "")
    }
  end)

upload_file = fn {src_path, dest_path} ->
  S3.put_object(
    System.fetch_env!("S3_BUCKET_NAME"),
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
    host: System.fetch_env!("AWS_ENDPOINT_URL_S3"),
    region: System.fetch_env!("AWS_REGION")
  )
end

paths
|> Task.async_stream(upload_file, max_concurrency: 10)
|> Stream.run()
