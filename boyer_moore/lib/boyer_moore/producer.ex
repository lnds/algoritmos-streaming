defmodule BoyerMoore.Producer do
  use GenStage


  def start_link(s) do
    GenStage.start_link(__MODULE__, s, name: __MODULE__)
  end
  
  def init(s) do
    {:producer, s} 
  end

  def handle_demand(demand, state) do
    events = Enum.to_list(0..demand) |> Enum.map(fn i -> 
      if i < 5 do 
          Enum.random(2..5)
      else 
        Enum.random(0..10) 
      end
    end)
    {:noreply, events, state}
  end
end
