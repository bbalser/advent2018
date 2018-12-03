defmodule Day1 do

  def part_one(input) do
    String.split(input, ~r/\n/)
    |> Enum.map(fn number when number == "" -> 0
                   number -> String.to_integer(number) end)
    |> Enum.sum()
  end

end
