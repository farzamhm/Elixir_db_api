defmodule ElixirApiDb.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      ElixirApiDb.Repo,
      # Start the Telemetry supervisor
      ElixirApiDbWeb.Telemetry,
      :poolboy.child_spec(:worker_pool, poolboy_config()),
      # Start the PubSub system
      {Phoenix.PubSub, name: ElixirApiDb.PubSub},
      # Start the Endpoint (http/https)
      ElixirApiDbWeb.Endpoint
      # Start a worker by calling: ElixirApiDb.Worker.start_link(arg)
      # {ElixirApiDb.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ElixirApiDb.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp poolboy_config do
    num_cores = :erlang.system_info(:schedulers_online)
    pool_size = num_cores * 2

    [
      name: {:local, :worker_pool},
      worker_module: ElixirApiDb.Servers.GetDataWorker,
      # Maximum number of workers
      size: pool_size,
      # Maximum number of temporary workers
      max_overflow: 2
    ]
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ElixirApiDbWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
