defmodule ElixirApiDb.Repo do
  use Ecto.Repo,
    otp_app: :elixir_api_db,
    adapter: Ecto.Adapters.MyXQL

  def init(_type, config) do
    {:ok, config}
  end

  def with_dynamic_repo(credentials, callback) do
    # a feature in Ecto that allows you to dynamically connect to different databases at runtime.
    default_dynamic_repo = get_dynamic_repo()
    start_opts = [name: nil, pool_size: 1] ++ credentials
    {:ok, repo} = ElixirApiDb.Repo.start_link(start_opts)

    try do
      ElixirApiDb.Repo.put_dynamic_repo(repo)
      callback.()
    after
      ElixirApiDb.Repo.put_dynamic_repo(default_dynamic_repo)
      Supervisor.stop(repo)
    end
  end
end
