defmodule Day1 do
  def part_one(input) do
    String.split(input, ~r/\n/)
    |> Enum.map(&to_integer/1)
    |> Enum.sum()
  end

  def part_two(input) do
    {:halted, answer} =
      String.split(input, ~r/\n/)
      |> Enum.map(&to_integer/1)
      |> Stream.cycle()
      |> Stream.filter(fn number -> number != 0 end)
      |> Enumerable.reduce({:cont, {0, []}}, fn next, {total, list} ->
        new_total = total + next

        case new_total in list do
          true -> {:halt, new_total}
          false -> {:cont, {new_total, [new_total | list]}}
        end
      end)

    answer
  end

  defp to_integer(number) when number == "", do: 0
  defp to_integer(number), do: String.to_integer(number)
end
