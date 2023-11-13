defmodule :"Elixir.Finances.Repo.Migrations.CreateBudget-table" do
  use Ecto.Migration

  def change do
    create table("budgets") do
      add :name, :string
      add :user_id, references("users")
      add :allocated_money, :integer
      add :currency, :integer
      add :start_date, :date
      add :end_date, :date
      timestamps()
    end

    create constraint("budgets", "allocated_money_should_be_positive",
             check: "allocated_money > 0",
             comment: "Allocated money should be positive"
           )

    create constraint("budgets", "budget_should_start_before_end",
             check: "start_date < end_date",
             comment: "Start date should be less then end date"
           )
  end
end
