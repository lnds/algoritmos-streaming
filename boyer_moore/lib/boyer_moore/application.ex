defmodule BoyerMoore.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    import Supervisor.Spec, warn: false
    children = [
      {BoyerMoore.Producer, 0},
      {BoyerMoore.Consumer, []}
    ] 

    # See https://hexocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: BoyerMoore.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
