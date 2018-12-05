defmodule Day5 do
  def part_one(input) do
    input
    |> String.trim()
    |> to_charlist()
    |> remove_reactions([])
    |> Enum.count()
  end

  defp remove_reactions([a, b | tail], []) when abs(a - b) == 32, do: remove_reactions(tail, [])

  defp remove_reactions([a, b | tail], [last | result]) when abs(a - b) == 32,
    do: remove_reactions([last | tail], result)

  defp remove_reactions([a, b | tail], result), do: remove_reactions([b | tail], [a | result])
  defp remove_reactions([], result), do: Enum.reverse(result)
  defp remove_reactions([a], result), do: Enum.reverse([a | result])
end
