defmodule FinancesBackend.Expense do
  @moduledoc """
  Expense Ecto schema. Represent the expenses that happen within a range of dates for a 
  given budget. And for a given account. Can have an optional comment.
  """
  alias FinancesBackend.Account
  alias FinancesBackend.Budget

  use Ecto.Schema

  schema "expenses" do
    belongs_to :budget, Budget
    belongs_to :account, Account
    field :date, :date
    field :amount, :integer
    field :comment, :string
    timestamps()
  end
end
