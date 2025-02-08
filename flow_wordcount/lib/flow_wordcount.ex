defmodule FlowWordcount do

  def main() do
    for arg <- System.argv() do
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
end
