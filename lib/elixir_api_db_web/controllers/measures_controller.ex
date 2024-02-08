defmodule ElixirApiDbWeb.MeasuresController do
  use ElixirApiDbWeb, :controller
  # alias ElixirApiDb.MeasuresData
  alias ElixirApiDb.MeasuresData
  require Logger

  def show(conn, %{"schema_name" => schema_name, "wave_counter" => wave_counter}) do
    # Your logic here, using schema_name and wave_counter
    case MeasuresData.get_data(schema_name, wave_counter) do
      nil ->
        send_resp(conn, 404, "Data not found")

      data ->
        Logger.debug("number of return records: #{inspect(length(data))}")
        json(conn, data)
    end
  end

  def latest(conn, %{"schema_name" => schema_name, "param" => param}) do
    case MeasuresData.get_latest(schema_name, param) do
      nil ->
        send_resp(conn, 404, "Data not found")

      data ->
        Logger.debug("number of return records: #{inspect(length(data))}")
        json(conn, data)
    end
  end
end
