defmodule EncodedStringAnalyzer.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      EncodedStringAnalyzerWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: EncodedStringAnalyzer.PubSub},
      # Start Finch
      {Finch, name: EncodedStringAnalyzer.Finch},
      # Start the Endpoint (http/https)
      EncodedStringAnalyzerWeb.Endpoint
      # Start a worker by calling: EncodedStringAnalyzer.Worker.start_link(arg)
      # {EncodedStringAnalyzer.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: EncodedStringAnalyzer.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    EncodedStringAnalyzerWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
