defmodule Day4 do
  def part_one(input) do
    sleep_data =
      input
      |> parse_sleep_data()
      |> Enum.group_by(fn %{id: id} -> id end)

    sleepiest_guard_id = get_sleepiest_guard(sleep_data)
    sleepiest_minute = get_sleepiest_minute(sleep_data[sleepiest_guard_id])

    String.to_integer(sleepiest_guard_id) * sleepiest_minute
  end

  def part_two(input) do
    {{id, minute}, _records} =
      parse_sleep_data(input)
      |> Enum.flat_map(fn %{id: id, start: start, stop: stop} ->
        Enum.zip(Stream.cycle([id]), start..(stop - 1))
      end)
      |> Enum.group_by(fn key -> key end)
      |> Enum.max_by(fn {_key, list} -> Enum.count(list) end)

    String.to_integer(id) * minute
  end

  defp parse_sleep_data(input) do
    input
    |> String.split(~r/\n/)
    |> Enum.filter(&(&1 != ""))
    |> Enum.map(&parse_record/1)
    |> Enum.sort_by(fn record ->
      {record["year"], record["month"], record["day"], record["hour"], record["minute"]}
    end)
    |> Enum.chunk_while([], &chunk_function/2, &after_function/1)
    |> Enum.map(&assign_ids/1)
    |> Enum.map(&convert_to_sleep_records/1)
    |> List.flatten()
  end

  defp get_sleepiest_guard(sleep_data) do
    {id, _total_hours_slept} =
      sleep_data
      |> Enum.map(fn {id, records} -> {id, total_and_sum(records)} end)
      |> Enum.max_by(fn {_id, total} -> total end)

    id
  end

  defp get_sleepiest_minute(guard_records) do
    {minute, _} =
      guard_records
      |> Enum.flat_map(fn %{start: start, stop: stop} ->
        Enum.to_list(start..(stop - 1))
      end)
      |> Enum.group_by(fn minute -> minute end)
      |> Enum.max_by(fn {_minute, list} -> Enum.count(list) end)

    minute
  end

  defp parse_record(line) do
    ~r/\[(?<year>\d{4})-(?<month>\d{2})-(?<day>\d{2})\s(?<hour>\d{2}):(?<minute>\d{2})\]\s(?<message>.+)$/
    |> Regex.named_captures(line)
  end

  defp chunk_function(next, acc) do
    case Regex.match?(~r/Guard #\d+\sbegins shift/, next["message"]) && acc != [] do
      true -> {:cont, Enum.reverse(acc), [next]}
      false -> {:cont, [next | acc]}
    end
  end

  defp after_function(acc), do: {:cont, Enum.reverse(acc), []}

  defp assign_ids(day_record) do
    id =
      Regex.named_captures(
        ~r/Guard #(?<id>\d+)\sbegins shift/,
        Map.get(hd(day_record), "message")
      )["id"]

    Enum.map(day_record, fn entry -> Map.put(entry, "id", id) end)
  end

  defp convert_to_sleep_records(day_record) do
    Enum.reduce(day_record, [], fn next, acc ->
      case next["message"] do
        "falls asleep" -> [%{id: next["id"], start: String.to_integer(next["minute"])} | acc]
        "wakes up" -> [Map.put(hd(acc), :stop, String.to_integer(next["minute"])) | tl(acc)]
        _ -> acc
      end
    end)
  end

  defp total_and_sum(records) do
    records
    |> Enum.map(fn %{stop: stop, start: start} -> stop - start end)
    |> Enum.sum()
  end
end
