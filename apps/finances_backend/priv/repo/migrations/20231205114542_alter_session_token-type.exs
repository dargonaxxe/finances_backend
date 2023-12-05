defmodule :"Elixir.Finances.Repo.Migrations.AlterSessionToken-type" do
  use Ecto.Migration

  def change do
    alter table("sessions") do
      remove :token
      add :token, :binary
    end
  end
end
