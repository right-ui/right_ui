defmodule RightUI.MixProject do
  use Mix.Project

  def project do
    [
      app: :right_ui,
      version: "0.1.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases()
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
      {:phoenix_live_view, "~> 0.17.10"},
      {:adept_svg, "~> 0.3.1"}
    ]
  end

  defp aliases do
    [
      setup: ["deps.get"],
      "sync.heroicons": [
        "cmd mkdir -p priv/icons",
        "cmd npm install heroicons --prefix priv/icons"
      ]
    ]
  end
end
