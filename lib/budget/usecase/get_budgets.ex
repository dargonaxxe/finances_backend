defmodule FinancesBackend.Budget.Usecase.GetBudgets do
  @moduledoc """
  A usecase that returns a list of budgets that belong to user with given user_id
  """
  alias Finances.Repo
  alias FinancesBackend.Budget

  import Ecto.Query

  @type id() :: integer()
  @spec execute(id()) :: list(Budget)
  def execute(user_id) do
    query = from b in Budget, where: b.user_id == ^user_id
    Repo.all(query)
  end
end
