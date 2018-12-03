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

end
