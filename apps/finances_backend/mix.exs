defmodule FinancesBackend.MixProject do
  use Mix.Project

  def project do
    [
      app: :finances_backend,
      build_path: "../../_build/",
      config_path: "../../config/config.exs",
      deps_path: "../../deps/",
      lockfile: "../../mix.lock",
      version: "0.1.0",
      elixir: "1.15.6",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      elixirc_paths: elixirc_paths(Mix.env())
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {FinancesBackend.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ecto, "3.10.3"},
      {:ecto_sql, "3.10.2"},
      {:postgrex, "0.17.3"},
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:bcrypt_elixir, "3.1.0"},
      {:uuid, "1.1.8"},
      {:money, "1.12.3"}
    ]
  end
end
