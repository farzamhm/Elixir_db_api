defmodule ElixirApiDb.Utils.Extractor do
  require Logger

  def extract_value_from_semi_json(input_string, value_key) do
    # Logger.debug("input_string: #{input_string}")

    # Adjust the regex pattern to match the specific format of 'report' strings
    # The pattern looks for the value_key followed by ':', optional spaces, a quote,
    # captures anything until the next quote, and then the closing quote.
    regex = ~r/(?:'#{value_key}'|"#{value_key}"|#{value_key})\s*:\s*["']([^"']*)["']/

    case Regex.run(regex, input_string) do
      [_, value] -> value
      nil -> :not_found
    end
  end

  def process_list(list, report_key) do
    # Logger.debug("list: #{inspect(list)}")
    # Logger.debug("process list with report_key: #{report_key}")

    Enum.map(list, fn map ->
      string_key_map = Map.new(map, fn {k, v} -> {Atom.to_string(k), v} end)

      case Map.get(string_key_map, report_key) do
        nil -> :no_report_key
        # Return the value of report_key
        report -> report
      end
    end)
  end

  def process_list(list, report_key, value_key) do
    # Logger.debug("list: #{inspect(list)}")
    # ogger.debug("process list with report_key: #{report_key} value_key: #{value_key}")

    Enum.map(list, fn map ->
      # Convert keys to strings
      string_key_map = Map.new(map, fn {k, v} -> {Atom.to_string(k), v} end)

      case Map.get(string_key_map, report_key) do
        nil ->
          :no_report_key

        _report when value_key == nil or value_key == "" ->
          :no_value_key

        report ->
          # Logger.debug("Extracting value from report: #{report}")
          extract_value_from_semi_json(report, value_key)
      end
    end)
  end
end
