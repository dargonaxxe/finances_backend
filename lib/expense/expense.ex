defmodule FinancesBackend.Expense do
  @moduledoc """
  Expense Ecto schema. Represent the expenses that happen within a range of dates for a 
  given budget. And for a given account. Can have an optional comment.
  """
  alias Ecto.Changeset
  alias FinancesBackend.Expense
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

  import Ecto.Changeset

  @spec changeset(Expense, Map) :: Changeset
  def changeset(%__MODULE__{} = expense, %{} = params) do
    expense
    |> cast(params, [:budget_id, :account_id, :date, :amount, :comment])
    |> validate_required([:budget_id, :account_id, :date, :amount])
    |> assoc_constraint(:budget)
    |> assoc_constraint(:account)
    |> check_constraint(:amount, name: "amount_should_be_positive")
  end
end
