defmodule FlowWordcount.MixProject do
  use Mix.Project

  def project do
    [
      app: :flow_wordcount,
      version: "0.1.0",
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {FlowWordcount.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:flow, "~> 1.2.4"}
    ]
  end
end
