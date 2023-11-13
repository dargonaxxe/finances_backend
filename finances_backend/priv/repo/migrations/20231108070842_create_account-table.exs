defmodule :"Elixir.Finances.Repo.Migrations.CreateAccount-table" do
  use Ecto.Migration

  def change do
    create table("accounts") do
      add :balance, :integer
      add :currency, :integer
      add :user_id, references("users")
      add :name, :string
      timestamps()
    end
  end
end
