defmodule :"Elixir.Finances.Repo.Migrations.CreateSession-table" do
  use Ecto.Migration

  def change do
    create table("sessions") do
      add :token, :string
      add :valid_until, :naive_datetime
      add :user_id, references("users")
      timestamps()
    end
  end
end
