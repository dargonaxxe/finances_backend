defmodule :"Elixir.Finances.Repo.Migrations.Add-users-indexUsername-unique" do
  use Ecto.Migration

  def change do
    create unique_index("users", [:username])
  end
end
