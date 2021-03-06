defmodule Day5 do
  def part_one(input) do
    input
    |> create_polymer()
    |> remove_reactions([])
    |> Enum.count()
  end

  defp remove_reactions([a, b | tail], []) when abs(a - b) == 32 do
    remove_reactions(tail, [])
  end

  defp remove_reactions([a, b | tail], [last | result]) when abs(a - b) == 32 do
    remove_reactions([last | tail], result)
  end

  defp remove_reactions([a, b | tail], result), do: remove_reactions([b | tail], [a | result])
  defp remove_reactions([], result), do: Enum.reverse(result)
  defp remove_reactions([a], result), do: Enum.reverse([a | result])

  def part_two(input) do
    polymer = create_polymer(input)

    Stream.map(?A..?Z, fn unit -> remove_unit_type(polymer, unit) end)
    |> Stream.map(fn polymer -> remove_reactions(polymer, []) end)
    |> Stream.map(fn polymer -> Enum.count(polymer) end)
    |> Enum.min()
  end

  defp remove_unit_type(polymer, unit) do
    unit_type = [unit, unit + 32]
    Enum.filter(polymer, fn x -> x not in unit_type end)
  end

  defp create_polymer(input) do
    input
    |> String.trim()
    |> to_charlist()
  end
end
