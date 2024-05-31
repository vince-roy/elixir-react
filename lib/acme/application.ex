defmodule Acme.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      AcmeWeb.Telemetry,
      Acme.Repo,
      {DNSCluster, query: Application.get_env(:acme, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Acme.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Acme.Finch},
      # Start a worker by calling: Acme.Worker.start_link(arg)
      # {Acme.Worker, arg},
      # Start to serve requests, typically the last entry
      AcmeWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Acme.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    AcmeWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
