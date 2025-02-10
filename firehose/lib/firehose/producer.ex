defmodule Firehose.Producer do
  use GenStage
  use WebSockex

  def start_link(url) do
    {:ok, pid} = GenStage.start_link(__MODULE__, :ok, name: __MODULE__)
    WebSockex.start_link(url, __MODULE__, pid)
  end

  def init(:ok) do
    {:producer, {:queue.new(), 0}, dispatcher: GenStage.BroadcastDispatcher}
  end

  def handle_frame({type, msg}, pid) do
    if type == :text do
      m = Jason.decode!(msg)

      if m != nil do
        GenServer.cast(pid, {:push, m})
      end
    end

    {:ok, pid}
  end

  def handle_cast({:push, msg} = frame, {queue, pending_demand}) do
    text = Map.get(msg, "commit", %{}) |> Map.get("record", %{}) |> Map.get("text", "")
    queue = :queue.in(text, queue)
    dispatch_events(queue, pending_demand, [])
  end

  def handle_cast({:send, frame}, state) do
    {:reply, frame, state}
  end

  def handle_demand(incoming_demand, {queue, pending_demand}) do
    dispatch_events(queue, incoming_demand + pending_demand, [])
  end

  def dispatch_events(queue, demand, events) do
    case :queue.out(queue) do
      {{:value, event}, queue} ->
        dispatch_events(queue, demand - 1, [event | events])

      {:empty, queue} ->
        {:noreply, Enum.reverse(events), {queue, demand}}
    end
  end
end
