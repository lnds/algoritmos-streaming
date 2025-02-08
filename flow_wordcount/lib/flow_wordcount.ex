defmodule FlowWordcount do

  def main() do
    
    for arg <- System.argv() do
      {time_in_microsecond, res}= :timer.tc(fn -> process_file(arg) end)
      IO.inspect(time_in_microsecond / 1000)
    end
  end

  def process_file(arg) do
      File.stream!(arg, :line)
      |> Flow.from_enumerable()
      |> Flow.flat_map(&String.split/1)
      |> Flow.partition()
      |> Flow.reduce(fn -> %{} end, fn word, map -> 
          Map.update(map, word, 1, &(&1 + 1))
        end)
      |> Enum.into([])
      |> List.keysort(1, :desc)
      |> IO.inspect()
    
  end
end
