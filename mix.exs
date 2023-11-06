defmodule FinancesBackend.MixProject do
  use Mix.Project

  def project do
    [
      app: :finances_backend,
      version: "0.1.0",
      elixir: "1.15.4",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

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
      {:bcrypt_elixir, "3.1.0"}
    ]
  end
end
