defmodule :"Elixir.Finances.Repo.Migrations.Create-tableExpenses" do
  use Ecto.Migration

  def change do
    create table("expenses") do
      add :budget_id, references("budgets")
      add :account_id, references("accounts")
      add :date, :date
      add :amount, :integer
      add :comment, :string
      timestamps()
    end

    create constraint("expenses", "amount_should_be_positive",
             check: "amount > 0",
             comment: "Amount should be positive"
           )
  end
end
