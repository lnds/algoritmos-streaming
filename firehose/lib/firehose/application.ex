defmodule Firehose.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    import Supervisor.Spec, warn: false
    url = "wss://jetstream2.us-east.bsky.network/subscribe\?wantedCollections=app.bsky.feed.post"

    children = [
      {Firehose.Producer, url},
      {Firehose.Consumer, []}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Firehose.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
