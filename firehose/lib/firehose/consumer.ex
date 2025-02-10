defmodule Firehose.Consumer do
  use GenStage

  def start_link(_initial) do
    GenStage.start_link(__MODULE__, Firehose.CountMin.new())
  end

  def init(state) do
    {:consumer, state, subscribe_to: [Firehose.Producer]}
  end

  def handle_events(events, _, counter) do
    new_counter =
      events
      |> Enum.flat_map(&String.split/1)
      |> Enum.reduce(counter, fn word, ct ->
        if String.starts_with?(word, "#") do
          Firehose.CountMin.add(ct, word)
        else
          counter
        end
      end)

    top = new_counter.top
    IO.puts("#{inspect(top)}")
    {:noreply, [], new_counter}
  end
end
