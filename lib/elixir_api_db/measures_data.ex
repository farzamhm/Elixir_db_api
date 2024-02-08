defmodule ElixirApiDb.MeasuresData do
  # import Ecto.Query
  require Logger

  defp execute_query(query, database, hostname) do
    try do
      ElixirApiDb.Repo.with_dynamic_repo(
        [
          database: database,
          hostname: hostname
        ],
        fn ->
          ElixirApiDb.Repo.all(query, timeout: 30_000)
        end
      )
    rescue
      exception ->
        Logger.error("Error in get_data: #{inspect(exception)}")
        []
    end
  end

  def get_data(schema_name, wave_counter) do
    hostname = "db.sandbox.brainboxai.net"
    query = ElixirApiDb.Queries.Queries.get_with_wave_counter(wave_counter)
    database = schema_name
    execute_query(query, database, hostname)
  end

  defp get_last_wave_counters(schema_name, n) do
    hostname = "db.sandbox.brainboxai.net"
    integer_n = String.to_integer(n)
    query = ElixirApiDb.Queries.Queries.get_last_n_wave_counter(integer_n)
    database = schema_name

    list = execute_query(query, database, hostname)

    list_extraction_agents = ElixirApiDb.Utils.Extractor.process_list(list, "report", "script_n")
    Logger.info(" extraction agents #{inspect(list_extraction_agents)}")

    # desired_number_of_records
    # number_of_required_wave_counter =
    n_required_records =
      ElixirApiDb.Utils.ListUtil.get_elements(list_extraction_agents, integer_n) |> length()

    ElixirApiDb.Utils.Extractor.process_list(list, "wave_counter")
    |> Enum.take(n_required_records)
    |> Enum.uniq()
  end

  def dispatch_tasks(schema_name, wave_counters) do
    wave_counters
    |> Enum.map(fn wave_counter ->
      Task.async(fn ->
        :poolboy.transaction(:worker_pool, fn pid ->
          GenServer.call(pid, {:process, schema_name, wave_counter})
        end)
      end)
    end)
    |> Enum.map(&Task.await/1)
  end

  def get_latest(schema_name, n) do
    wave_counters = get_last_wave_counters(schema_name, n)
    dispatch_tasks(schema_name, wave_counters) |> List.flatten()
  end
end

# def make_it_unique(n) do
# end
