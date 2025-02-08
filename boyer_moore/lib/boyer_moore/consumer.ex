defmodule BoyerMoore.Consumer do
  use GenStage

  def start_link(_initial) do
    GenStage.start_link(__MODULE__, {nil, 0})
  end
  
  def init(state) do
    {:consumer, state, subscribe_to: [{BoyerMoore.Producer, max_demand: 10}]}
  end
  
  def handle_events(events, _from, {m, c}=state) do
    new_state = events 
      |> Enum.reduce({m,c}, fn x, {m,c} -> 
        if c == 0 do
          {x, 1}
        else
          if m == x do
            {m, c + 1}
          else 
            {m, c - 1}
          end
        end
      end)
    #    IO.puts("events: #{inspect(events)}")
    IO.puts("new state: #{inspect(new_state)}, old state: #{inspect(state)}")
    {:noreply, [], new_state}
  end
end
