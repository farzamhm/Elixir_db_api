defmodule ElixirApiDb.Utils.ListUtil do
  def get_elements(list, n) do
    first_element = List.first(list)
    do_get_elements(list, n, first_element, 0, [])
  end

  defp do_get_elements([], _n, _first_element, _count, acc), do: Enum.reverse(acc)

  defp do_get_elements([head | tail], n, first_element, count, acc) do
    if head == first_element do
      if count < n do
        # If head is the first element and count is less than n, increment count
        do_get_elements(tail, n, first_element, count + 1, [head | acc])
      else
        # If head is the first element and count is n, stop and return the accumulator
        Enum.reverse(acc)
      end
    else
      # If head is not the first element, continue adding elements
      do_get_elements(tail, n, first_element, count, [head | acc])
    end
  end
end
