defmodule Day3 do
  def part_one(input) do
    input
    |> get_all_records()
    |> Enum.reduce(%{}, &track_ids_by_coordinates/2)
    |> Enum.filter(fn {_k, v} -> Enum.count(v) > 1 end)
    |> Enum.count()
  end

  defp parse_record(record) do
    ~r/#(?<id>\d+)\s@\s(?<left>\d+),(?<top>\d+):\s(?<width>\d+)x(?<height>\d+)/
    |> Regex.named_captures(record)
    |> Enum.map(fn {k, v} -> {String.to_atom(k), String.to_integer(v)} end)
    |> Enum.into(%{})
  end

  defp generate_coordinates(record) do
    x_coordinates = record[:left]..(record[:left] + record[:width] - 1)
    y_coordinates = record[:top]..(record[:top] + record[:height] - 1)

    for x <- x_coordinates,
        y <- y_coordinates do
      {x, y}
    end
  end

  defp track_ids_by_coordinates(record, map) do
    generate_coordinates(record)
    |> Enum.reduce(map, fn key, acc ->
      Map.update(acc, key, [record[:id]], &[record[:id] | &1])
    end)
  end

  def part_two(input) do
    all_records = get_all_records(input)
    collisions = get_collisions(all_records)

    Enum.map(all_records, fn record -> record[:id] end) -- MapSet.to_list(collisions)
  end

  defp update_mapset({_key, list}, mapset) do
    MapSet.union(mapset, MapSet.new(list))
  end

  defp get_all_records(input) do
    String.split(input, ~r/\n/)
    |> Enum.filter(&(&1 != ""))
    |> Enum.map(&parse_record/1)
  end

  defp get_collisions(records) do
    records
    |> Enum.reduce(%{}, &track_ids_by_coordinates/2)
    |> Enum.filter(fn {_k, v} -> Enum.count(v) > 1 end)
    |> Enum.reduce(MapSet.new(), &update_mapset/2)
  end
end
