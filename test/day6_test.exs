defmodule Day6Tests do
  use ExUnit.Case

  test "part_one" do
    input = """
    1, 1
    1, 6
    8, 3
    3, 4
    5, 5
    8, 9
    """

    assert Day6.part_one(input) == 17
  end

  test "part_two" do
    input = """
    1, 1
    1, 6
    8, 3
    3, 4
    5, 5
    8, 9
    """

    assert Day6.part_two(input) == 16
  end
end
