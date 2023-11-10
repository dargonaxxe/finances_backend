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
    field :daily_prognosis, :integer
    timestamps()
  end

  import Ecto.Changeset

  @name_min_length 3
  def changeset(%__MODULE__{} = budget, %{} = params) do
    budget
    |> cast(params, [:name, :user_id, :allocated_money, :currency, :start_date, :end_date])
    |> change(daily_prognosis: calculate_daily_prognosis(params))
    |> validate_required([
      :name,
      :user_id,
      :allocated_money,
      :currency,
      :start_date,
      :end_date
    ])
    |> validate_length(:name, min: @name_min_length)
    |> assoc_constraint(:user)
    |> check_constraint(:allocated_money, name: "allocated_money_should_be_positive")
    |> check_constraint(:start_date, name: "budget_should_start_before_end")
  end

  defp calculate_daily_prognosis(%{} = params) do
    amount = params[:allocated_money]
    start_date = params[:start_date]
    end_date = params[:end_date]
    amount && start_date && end_date && calculate_daily_prognosis(amount, start_date, end_date)
  end

  defp calculate_daily_prognosis(amount, %Date{} = start_date, %Date{} = end_date) do
    div(amount, count_days(start_date, end_date))
  end

  defp count_days(%Date{} = start_date, %Date{} = end_date) do
    {start_day, _} = Date.day_of_era(start_date)
    {end_day, _} = Date.day_of_era(end_date)
    end_day - start_day + 1
  end
end
