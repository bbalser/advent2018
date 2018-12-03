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

  test "part_two should identify prototypes" do
    input = """
    abcde
    fghij
    klmno
    pqrst
    fguij
    axcye
    wvxyz
    """

    assert Day2.part_two(input) == "fgij"
  end

end
