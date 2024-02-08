defmodule ElixirApiDb.Servers.GetDataWorker do
  use GenServer

  # Client API

  def start_link(_) do
    GenServer.start_link(__MODULE__, :ok, [])
  end

  # Server Callbacks

  def init(:ok) do
    {:ok, %{}}
  end

  def handle_call({:process, schema_name, wave_counter}, _from, state) do
    # Handle the task
    result = ElixirApiDb.MeasuresData.get_data(schema_name, wave_counter)
    {:reply, result, state}

    # You can define other callback functions as needed
  end
end
