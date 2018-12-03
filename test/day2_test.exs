defmodule Day2Tests do
  use ExUnit.Case

  test "part_one should create checksum" do
    input = """
    abcdef
    bababc
    abbcde
    abcccd
    aabcdd
    abcdee
    ababab
    """

    assert Day2.part_one(input) == 12
  end

end
