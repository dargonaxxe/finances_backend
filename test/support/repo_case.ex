defmodule FinancesBackend.RepoCase do
  @moduledoc """
  Module that enables the ability to work with Finances.Repo for specific test.
  """
  use ExUnit.CaseTemplate

  using do
    quote do
      alias Finances.Repo

      import Ecto
      import Ecto.Query
      import FinancesBackend.RepoCase
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Finances.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Finances.Repo, {:shared, self()})
    end

    :ok
  end
end
