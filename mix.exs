defmodule FinancesBackend.MixProject do
  use Mix.Project

  def project do
    [
      app: :finances_backend,
      version: "0.1.0",
      elixir: "1.15.6",
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
      {:ecto, "3.10.3"},
      {:ecto_sql, "3.10.2"},
      {:postgrex, "0.17.3"}
    ]
  end
end
