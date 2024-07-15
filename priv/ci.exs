app_name = "acme-by-vince-roy"

prebuild_checks = fn ->
  [
    {"npm", ["run", "--prefix", "client/expo", "check-types"]},
    {"npm", ["run", "--prefix", "client/marketing", "check-types"]},
    {"npm", ["run", "--prefix", "client/expo", "lint"]},
    {"npm", ["run", "--prefix", "client/marketing", "lint"]},
    {"mix", ["test"]}
  ]
  |> Enum.map(fn {cmd, args} -> Task.async(fn -> System.cmd(cmd, args, into: IO.stream()) end) end)
  |> Enum.any?(fn task -> elem(Task.await(task), 1) === 1 end)
  |> case do
    false -> :ok
    _ -> :error
  end
end

fly_deploy = fn ->
  System.cmd("fly", ["deploy"], stderr_to_stdout: true)
  |> elem(0)
  |> String.downcase()
  |> String.contains?("could not find app")
  |> if do
    System.cmd("fly", ["apps", "create", app_name])
    System.cmd("fly", ["ips", "allocate-v6", "--app", app_name])
  else
    System.cmd("fly", ["deploy"])
  end
end

deploy = fn ->
  upload_files = Task.async(fn -> System.cmd("elixir", ["priv/asset_upload.exs"]) end)
  deploy = Task.async(fn -> fly_deploy.() end)

  if Task.await(upload_files) === 1 do
    Task.shutdown(deploy)
  end
end

merge = fn ->
  {current_branch, 0} = System.cmd("git", ["branch", "--show-current"])
  current_branch = String.trim(current_branch)
  System.cmd("git", ["merge", "--squash", current_branch])
  System.cmd("git", ["checkout", "master"])
end
