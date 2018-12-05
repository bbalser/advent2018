defmodule Day5Tests do
  use ExUnit.Case

  test "part_one should stuff" do
    input = "dabAcCaCBAcCcaDA"

    assert Day5.part_one(input) == 10
  end
end
