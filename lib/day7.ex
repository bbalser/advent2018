defmodule Day7 do
  import NimbleParsec

  @num_workers 5

  defparsecp(
    :parse_input_line,
    ignore(string("Step "))
    |> ascii_string([?A..?Z], 1)
    |> ignore(string(" must be finished before step "))
    |> ascii_string([?A..?Z], 1)
    |> ignore(string(" can begin."))
  )

  defp parse(input_line) do
    {:ok, [a, b], _, _, _, _} = parse_input_line(input_line)
    %{name: b, depends_on: a}
  end

  def part_one(input) do
    input
    |> create_dependency_map()
    |> process_steps([])
    |> Enum.join()
  end

  defp create_dependency_map(input) do
    input
    |> String.split(~r/\n/, trim: true)
    |> Enum.map(&parse/1)
    |> Enum.reduce(%{}, fn %{name: name, depends_on: dependency}, map ->
      Map.update(map, name, [dependency], &[dependency | &1])
      |> Map.put_new(dependency, [])
    end)
  end

  defp process_steps(map, result) when map == %{}, do: Enum.reverse(result)

  defp process_steps(map, result) do
    {next, new_map} = find_next_step(map)

    process_steps(complete_step(new_map, next), [next | result])
  end

  defp find_next_step(map) do
    next =
      map
      |> Enum.filter(fn {_k, v} -> v == [] end)
      |> Enum.map(fn {k, _v} -> k end)
      |> Enum.sort()
      |> List.first()

    {next, Map.delete(map, next)}
  end

  defp complete_step(map, nil), do: map

  defp complete_step(map, step) do
    Enum.map(map, fn {k, v} -> {k, Enum.filter(v, fn x -> x != step end)} end)
    |> Enum.into(%{})
  end

  def part_two(input) do
    dependency_map = create_dependency_map(input)
    workers = Enum.map(1..@num_workers, fn _ -> {nil, 0} end)
    tick(dependency_map, workers, 0)
  end

  defp run_out_time(_workers, time, true = _all_done), do: time

  defp run_out_time(workers, time, false) do
    new_workers = Enum.map(workers, fn {s, tleft} -> {s, max(0, tleft - 1)} end)
    run_out_time(new_workers, time + 1, all_done?(new_workers))
  end

  defp all_done?(workers) do
    Enum.all?(workers, fn {_step, time_left} -> time_left == 0 end)
  end

  defp tick(map, workers, time) when map == %{} do
    run_out_time(workers, time, all_done?(workers))
  end

  defp tick(steps, workers, time) do
    {new_steps, new_workers} =
      workers
      |> Enum.sort()
      |> Enum.reverse()
      |> Enum.reduce({steps, []}, fn {step, time_left}, {remaining_steps, w_list} ->
        case time_left == 0 do
          false ->
            {remaining_steps, [{step, time_left - 1} | w_list]}

          true ->
            {next, new_remaining_steps} =
              remaining_steps
              |> complete_step(step)
              |> find_next_step()

            {new_remaining_steps, [{next, determine_time(next)} | w_list]}
        end
      end)

    tick(new_steps, new_workers, time + 1)
  end

  defp determine_time(nil), do: 0

  defp determine_time(step) do
    60 + (step |> to_charlist() |> hd) - 65
  end
end
