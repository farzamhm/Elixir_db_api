defmodule ElixirApiDb.Schemas.ExtractionCycle do
  use Ecto.Schema

  schema "extraction_cycle" do
    field :cycle_duration, :integer
    field :wave_counter, :integer
    field :report, :string
    field :detail_report, :binary
    field :row_created, :utc_datetime
  end
end
