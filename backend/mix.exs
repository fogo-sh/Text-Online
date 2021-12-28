defmodule TextOnline.MixProject do
  use Mix.Project

  def project do
    [
      app: :textonline,
      version: "0.1.0",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      mod: {TextOnline, []},
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:cowboy, "~> 2.9"},
      {:plug, "~> 1.12"},
      {:plug_cowboy, "~> 2.5"},
      {:jason, "~> 1.3"}
    ]
  end
end
