defmodule RightUI.MixProject do
  use Mix.Project

  def project do
    [
      app: :right_ui,
      version: "0.1.0",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:phoenix_live_view,
       github: "phoenixframework/phoenix_live_view", ref: "e9d41cb", override: true}
    ]
  end
end
