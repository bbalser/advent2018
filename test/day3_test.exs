defmodule Day3Tests do
  use ExUnit.Case

  test "part_one should identity multi claim inches" do
    input = """
    #1 @ 1,3: 4x4
    #2 @ 3,1: 4x4
    #3 @ 5,5: 2x2
    #123 @ 10,10: 20x40
    """

    assert Day3.part_one(input) == 4
  end

  test "part_two should identity non overlapping claim" do
    input = """
    #1 @ 1,3: 4x4
    #2 @ 3,1: 4x4
    #3 @ 5,5: 2x2
    """

    assert Day3.part_two(input) == [3]
  end
end
