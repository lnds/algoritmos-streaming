defmodule Firehose.MixProject do
  use Mix.Project

  def project do
    [
      app: :firehose,
      version: "0.1.0",
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      # applications: [:websockex],
      extra_applications: [:websockex, :logger],
      mod: {Firehose.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:websockex, "~> 0.4.3"},
      {:gen_stage, "~> 1.2.1"},
      {:jason, "~> 1.4"},
      {:heap, "~> 3.0.0"},
    ]
  end
end
