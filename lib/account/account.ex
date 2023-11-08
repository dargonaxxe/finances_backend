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

  import Ecto.Changeset

  @name_min_length 3
  def changeset(%__MODULE__{} = account, %{} = params) do
    account
    |> cast(params, [:balance, :currency, :user_id, :name])
    |> validate_required([:balance, :currency, :user_id, :name])
    |> assoc_constraint(:user)
    |> validate_length(:name, min: @name_min_length)
  end
end
