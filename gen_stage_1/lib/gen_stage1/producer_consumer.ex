defmodule GenStage1.ProducerConsumer do
  use GenStage

  require Integer

  def start_link(_initial) do
    GenStage.start_link(__MODULE__, :state_doesnt_matter, name: __MODULE__)
  end
  

  def init(state) do
    {:producer_consumer, state, subscribe_to: [GenStage1.Producer]}
  end

  def handle_events(events, _from, state) do
    numbers = events |> Enum.filter(&Integer.is_odd/1)
    {:noreply, numbers, state}
  end
end
