defmodule FinancesBackend.Budget.Usecase.WithBudget do
  @moduledoc """
  Usecase that retrieves a budget, and applies some lambda to it. If budget is not found, 
  returns an error
  """
  alias FinancesBackend.Budget
  alias FinancesBackend.Budget.Usecase.GetBudget

  def execute(budget_id, lambda) do
    case GetBudget.execute(budget_id) do
      nil ->
        {:error, {:invalid_budget_id, budget_id}}

      %Budget{} = budget ->
        lambda.(budget)
    end
  end
end
