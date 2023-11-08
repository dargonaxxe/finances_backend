defmodule FinancesBackend.Account do
  @moduledoc """
  Account ecto model. Contains balance, currency, name, user_id, timestamps. Updates with every transaction that affects given account. 
  """
  alias FinancesBackend.User

  use Ecto.Schema

  schema "accounts" do
    field :balance, :integer
    field :currency, :integer
    belongs_to :user, User
    field :name, :string
    timestamps()
  end
end
