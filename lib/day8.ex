defmodule Day8 do
  def part_one(input) do
    {_remaining, root_node} =
      input
      |> String.split(~r/[\s\n]/, trim: true)
      |> Enum.map(fn x -> String.to_integer(x) end)
      |> process_data()

    sum_metadata(root_node)
  end

  def sum_metadata(node) do
    [node[:metadata] | Enum.map(node[:children], &sum_metadata/1)]
    |> List.flatten()
    |> Enum.sum()
  end

  defp process_data([num_children, num_metadata | tail]) do
    {remaining_data, children} = get_children(num_children, tail)

    metadata = Enum.take(remaining_data, num_metadata)
    node = %{metadata: metadata, children: Enum.reverse(children)}

    {Enum.drop(remaining_data, num_metadata), Map.put(node, :value, determine_value(node))}
  end

  defp get_children(0, data), do: {data, []}
  defp get_children(num_children, data) do
    Enum.reduce(1..num_children, {data, []}, fn _num, {nodes, children} ->
      {d, c} = process_data(nodes)
      {d, [c | children]}
    end)
  end

  defp determine_value(%{metadata: metadata, children: []}) do
    Enum.sum(metadata)
  end

  defp determine_value(%{metadata: metadata, children: children}) do
    Enum.map(metadata, fn index ->
      Enum.at(children, index-1, %{value: 0})[:value]
    end)
    |> Enum.sum()
  end

  def part_two(input) do
    {_remaining, root_node} =
      input
      |> String.split(~r/[\s\n]/, trim: true)
      |> Enum.map(fn x -> String.to_integer(x) end)
      |> process_data()

    root_node[:value]
  end
end
