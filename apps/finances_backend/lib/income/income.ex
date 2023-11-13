defmodule FinancesBackend.Income do
  @moduledoc """
  Income ecto schema. Refers to account. Contains fields: amount, comment, timestamps(). 
  """
  alias Ecto.Changeset
  alias FinancesBackend.Income
  alias FinancesBackend.Account

  use Ecto.Schema

  schema "incomes" do
    belongs_to :account, Account
    field :amount, :integer
    field :comment, :string
    field :date, :date
    timestamps()
  end

  import Ecto.Changeset

  @spec changeset(Income, Map) :: Changeset
  def changeset(%Income{} = income, %{} = params) do
    income
    |> cast(params, [:account_id, :amount, :comment, :date])
    |> validate_required([:account_id, :amount, :date])
    |> assoc_constraint(:account)
    |> check_constraint(:amount, name: "income_amount_should_be_positive")
  end
end
