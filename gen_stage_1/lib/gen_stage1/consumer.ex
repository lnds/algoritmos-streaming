defmodule GenStage1.Consumer do
  use GenStage

  def start_link(_initial) do
    GenStage.start_link(__MODULE__, :state_doesnt_matter)
  end
  
  def init(state) do
    {:consumer, state, subscribe_to: [GenStage1.ProducerConsumer]}
  end
  

  def handle_events(events, _from, state) do
    for event <- events do
      IO.inspect({self(), event, state})
    end

    # a consumer never emit events
    {:noreply, [], state}
  end
end
