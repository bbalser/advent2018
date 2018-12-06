defmodule Day6 do
  @initial_acc %{min_x: 1000, max_x: 0, min_y: 1000, max_y: 0}

  def part_one(input) do
    coordinates = parse_coordinates(input)
    ranges = calculate_ranges(coordinates)

    distances =
      for x <- ranges[:min_x]..ranges[:max_x],
          y <- ranges[:min_y]..ranges[:max_y] do
        {x, y}
      end
      |> Enum.reduce(%{}, fn {x, y}, acc ->
        case determine_closest_coordinate({x, y}, coordinates) do
          {:ok, min_distance} -> Map.put(acc, {x, y}, min_distance)
          :none -> acc
        end
      end)

    {_, matches} =
      Enum.group_by(
        distances,
        fn {{_x, _y}, {cx, cy, _}} -> {cx, cy} end,
        fn {{x, y}, _} -> {x, y} end
      )
      |> Enum.filter(fn {{_cx, _cy}, list} -> not is_infinite?(list, ranges) end)
      |> Enum.max_by(fn {_k, v} -> Enum.count(v) end)

    Enum.count(matches)
  end

  defp is_infinite?(list, ranges) do
    Enum.all?(list, fn {x, y} ->
      x == ranges[:min_x] && x == ranges[:max_x] && y == ranges[:min_y] && y == ranges[:max_y]
    end)
  end

  defp determine_closest_coordinate(coordinate, coordinates) do
    distances =
      Enum.map(coordinates, fn {cx, cy} ->
        {cx, cy, manhatten_distance(coordinate, {cx, cy})}
      end)

    {_, _, min_count} = min_distance = Enum.min_by(distances, fn {_, _, distance} -> distance end)

    case Enum.count(distances, fn {_, _, count} -> count == min_count end) do
      1 -> {:ok, min_distance}
      _ -> :none
    end
  end

  defp calculate_ranges(coordinates) do
    Enum.reduce(coordinates, @initial_acc, fn {x, y}, %{min_x: min_x, max_x: max_x, min_y: min_y, max_y: max_y} = acc ->
      %{acc | min_x: min(min_x, x), max_x: max(max_x, x), min_y: min(min_y, y), max_y: max(max_y, y)}
    end)
  end

  defp parse_coordinates(input) do
    input
    |> String.trim()
    |> String.split(~r/\n/)
    |> Enum.map(fn string -> String.split(string, ", ") |> List.to_tuple() end)
    |> Enum.map(fn {x, y} -> {String.to_integer(x), String.to_integer(y)} end)
  end

  defp manhatten_distance({x1, y1}, {x2, y2}) do
    abs(x1 - x2) + abs(y1 - y2)
  end
end
