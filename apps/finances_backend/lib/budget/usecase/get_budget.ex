defmodule FinancesBackend.Budget.Usecase.GetBudget do
  @moduledoc """
  Use case to retrieve a budget by its id 
  """
  alias FinancesBackend.Budget
  alias Finances.Repo

  @type id() :: integer()
  @spec execute(id()) :: Budget | nil
  def execute(id) do
    Repo.get_by(Budget, id: id)
  end
end
