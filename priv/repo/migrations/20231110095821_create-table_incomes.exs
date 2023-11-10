defmodule :"Elixir.Finances.Repo.Migrations.Create-tableIncomes" do
  use Ecto.Migration

  def change do
    create table("incomes") do
      add :account_id, references("accounts")
      add :amount, :integer
      add :comment, :string
      timestamps()
    end

    create constraint("incomes", "income_amount_should_be_positive",
             check: "amount > 0",
             comment: "Amount should be positive"
           )
  end
end
