defmodule InfotechChat.MixProject do
  use Mix.Project

  def project do
    [
      releases: [
        infotech_chat: [
          include_executables_for: [:unix],
          applications: [runtime_tools: :permanent, mix: :permanent]
        ]
      ],
      app: :infotech_chat,
      version: "0.1.1",
      elixir: "~> 1.16",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {InfotechChat.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:n2o, "~> 11.9"},
      {:nitro, "~> 9.9"},
      {:bandit, "~> 1.6"},
      {:plug, "~> 1.16"},
      {:syn, "~> 2.1.1"},
      {:cachex, "~> 4.0"},
      {:tzdata, "~> 1.1.2"}
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end
end
