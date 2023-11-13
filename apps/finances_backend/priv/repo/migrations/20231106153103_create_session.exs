defmodule Finances.Repo.Migrations.CreateSession do
  use Ecto.Migration

  def change do
    create table("users") do
      add :username, :string
      add :password, :string
      add :salt, :string
      timestamps()
    end
  end
end
