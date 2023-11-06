defmodule Finances.Repo.Migrations.CreateSession do
  use Ecto.Migration

  def change do
    create table("users") do
      field :username, :string
      field :password, :string
      field :salt, :string
      timestamps()
    end
  end
end
