defmodule FinancesBackend.Budget do
  @moduledoc """
  Budget ecto model. Contains: name, user_id, allocated_money, currency, start_date, end_date
  """
  alias FinancesBackend.User

  use Ecto.Schema

  schema "budgets" do
    field :name, :string
    belongs_to :user, User
    field :allocated_money, :integer
    field :currency, :integer
    field :start_date, :date
    field :end_date, :date
    timestamps()
  end
end
