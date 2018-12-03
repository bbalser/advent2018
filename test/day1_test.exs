defmodule Day1Tests do
  use ExUnit.Case

  test "part_one add numbers" do
    input = """
    10
    5
    4
    """

    assert Day1.part_one(input) == 19
  end

  test "part_two detect first double frequency" do
    input = """
    3
    3
    4
    -2
    -4
    """

    assert Day1.part_two(input) == 10
  end
end
