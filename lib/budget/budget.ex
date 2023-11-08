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

  import Ecto.Changeset

  @name_min_length 3
  def changeset(%__MODULE__{} = budget, %{} = params) do
    budget
    |> cast(params, [:name, :user_id, :allocated_money, :currency, :start_date, :end_date])
    |> validate_required([:name, :user_id, :allocated_money, :currency, :start_date, :end_date])
    |> validate_length(:name, min: @name_min_length)
    |> assoc_constraint(:user)
    |> check_constraint(:allocated_money, name: "allocated_money_should_be_positive")
    |> check_constraint(:start_date, name: "budget_should_start_before_end")
  end
end
