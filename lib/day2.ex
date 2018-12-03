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
    |> to_charlist()
    |> Enum.reduce(%{}, fn next, map ->
      Map.update(map, next, 1, &(&1 + 1))
    end)
  end

  defp has_count?(map, count) do
    Enum.any?(map, fn {_k,v} -> v == count end)
  end

  def part_two(input) do
    ids = String.split(input, ~r/\n/)
    |> Enum.filter(fn string -> string != "" end)

    for x <- ids,
      y <- ids do
        count_differences(x,y)
    end
    |> Enum.find(fn {count, _} -> count == 1 end)
    |> elem(1)
  end

  defp count_differences(one, two) do
    count = Enum.zip(to_charlist(one), to_charlist(two))
    |> Enum.filter(fn {a,b} -> a != b end)
    |> Enum.count()

    {count, keep_same(one, two)}
  end

  defp keep_same(one, two) do
    Enum.zip(to_charlist(one), to_charlist(two))
    |> Enum.filter(fn {a, b} -> a == b end)
    |> Enum.map(fn {a, _b} -> a end)
    |> to_string()
  end

end
