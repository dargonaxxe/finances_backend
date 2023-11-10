defmodule FinancesBackend.Income do
  @moduledoc """
  Income ecto schema. Refers to account. Contains fields: amount, comment, timestamps(). 
  """
  alias FinancesBackend.Account

  use Ecto.Schema

  schema "incomes" do
    belongs_to :account, Account
    field :amount, :integer
    field :comment, :string
    timestamps()
  end
end
