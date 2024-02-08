defmodule ElixirApiDb.Queries.Queries do
  import Ecto.Query

  def get_with_wave_counter(wave_counter) do
    from t in ElixirApiDb.HsMeasures,
      where: t.wave_counter == ^wave_counter,
      limit: 100_000,
      select: %{
        point_id: t.point_id,
        point_value: t.point_value,
        creation_date_utc: t.creation_date_utc,
        wave_counter: t.wave_counter
      }
  end

  alias ElixirApiDb.Schemas.ExtractionCycle

  def get_last_n_wave_counter(n) do
    from t in ExtractionCycle,
      # distinct: t.wave_counter,
      order_by: [desc: t.id],
      limit: ^(n * 10),
      select: %{
        wave_counter: t.wave_counter,
        report: t.report,
        row_created: t.row_created
      }

    # subquery =
    #   from t in ExtractionCycle,
    #     distinct: t.wave_counter,
    #     select: %{wave_counter: t.wave_counter}

    # from s in subquery,
    #   order_by: [desc: s.wave_counter],
    #   limit: ^n
  end
end
