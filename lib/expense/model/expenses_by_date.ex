defmodule FinancesBackend.Expense.Model.ExpensesByDate do
  @moduledoc """
  Model that represents expensese by date for a given budget
  """
  alias FinancesBackend.Expense

  @type t :: %__MODULE__{
          cumulative_expenses: integer(),
          local_expenses: integer(),
          budget_proficit: integer(),
          expenses: list(Expense)
        }
  defstruct [:cumulative_expenses, :local_expenses, :budget_proficit, :expenses]
end
