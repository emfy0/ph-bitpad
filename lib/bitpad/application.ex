defmodule Bitpad.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      BitpadWeb.Telemetry,
      # Start the Ecto repository
      Bitpad.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Bitpad.PubSub},
      # Start Finch
      {Finch, name: Bitpad.Finch},
      # Start the Endpoint (http/https)
      BitpadWeb.Endpoint
      # Start a worker by calling: Bitpad.Worker.start_link(arg)
      # {Bitpad.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Bitpad.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    BitpadWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
