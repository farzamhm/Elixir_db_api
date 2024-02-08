defmodule ElixirApiDb.HsMeasures do
  use Ecto.Schema

  schema "hs_measures" do
    field :point_id, :integer
    field :point_value, :float
    field :wave_counter, :integer
    field :created_by, :string
    field :row_created, :utc_datetime
    field :creation_date_utc, :utc_datetime
    field :source_ts_utc, :utc_datetime
  end
end
