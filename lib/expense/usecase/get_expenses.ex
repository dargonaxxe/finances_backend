defmodule FinancesBackend.Expense.Usecase.GetExpenses do
  @moduledoc """
  Usecase that returns a list of expenses for a given budget for a given date. If date does not 
  belong to budget, returns an empty list
  """
  alias FinancesBackend.Expense
  alias Finances.Repo

  import Ecto.Query

  def execute(budget_id, %Date{} = date) do
    query = from e in Expense, where: e.budget_id == ^budget_id and e.date == ^date
    Repo.all(query)
  end

  def execute(budget_id) do
    query = from e in Expense, where: e.budget_id == ^budget_id, order_by: [asc: :date]
    Repo.all(query)
  end
end
