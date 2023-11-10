defmodule :"Elixir.Finances.Repo.Migrations.Alter-incomesAdd-date-field" do
  use Ecto.Migration

  def change do
    alter table("incomes") do
      add :date, :date
    end
  end
end
