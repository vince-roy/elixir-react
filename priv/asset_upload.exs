alias ExAws.S3

Mix.install([
  {:dotenvy, "~> 0.8.0"},
  {:ex_aws_s3, "~> 2.3"},
  {:hackney, "~> 1.18"},
  {:jason, "~> 1.2"}
])

{:ok,
 %{
   "AWS_ACCESS_KEY_ID" => access_key_id,
   "AWS_ENDPOINT_URL_S3" => host,
   "AWS_REGION" => region,
   "AWS_SECRET_ACCESS_KEY" => secret_access_key,
   "S3_BUCKET_NAME" => bucket_name
 }} = Dotenvy.source([".env", System.get_env()])

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
    bucket_name,
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
    access_key_id: access_key_id,
    host: host,
    region: region,
    secret_access_key: secret_access_key
  )
end

paths
|> Task.async_stream(upload_file, max_concurrency: 10)
|> Stream.run()
