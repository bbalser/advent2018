defmodule Day2 do

  def part_one(input) do
    data = String.split(input, ~r/\n/)
    |> Enum.filter(fn entry -> entry != "" end)
    |> Enum.map(&count_letters/1)

    twos = Enum.filter(data, fn map -> has_count?(map, 2) end) |> Enum.count()
    threes = Enum.filter(data, fn map -> has_count?(map, 3) end) |> Enum.count()

    twos * threes
  end


  defp count_letters(entry) do
    entry
    |> to_char_list()
    |> Enum.reduce(%{}, fn next, map ->
      Map.update(map, next, 1, &(&1 + 1))
    end)
  end

  defp has_count?(map, count) do
    Enum.any?(map, fn {_k,v} -> v == count end)
  end

end
