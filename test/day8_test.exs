defmodule Day8Tests do
  use ExUnit.Case

  test "part_one" do
    input = "2 3 0 3 10 11 12 1 1 0 1 99 2 1 1 2"

    assert Day8.part_one(input) == 138
  end

  test "part_two" do
    input = "2 3 0 3 10 11 12 1 1 0 1 99 2 1 1 2"

    assert Day8.part_two(input) == 66
  end
end
