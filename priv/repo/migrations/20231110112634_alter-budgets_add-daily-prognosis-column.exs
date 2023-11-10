defmodule :"Elixir.Finances.Repo.Migrations.Alter-budgetsAdd-daily-prognosis-column" do
  use Ecto.Migration

  def change do
    alter table("budgets") do
      add :daily_prognosis, :integer
    end
  end
end
