defmodule FinancesBackend.Session do
  @moduledoc """
  Session Ecto model. 
  """
  alias FinancesBackend.User
  use Ecto.Schema

  schema "sessions" do
    field :token, :binary
    field :valid_until, :naive_datetime
    belongs_to :user, User
    timestamps()
  end

  import Ecto.Changeset

  def changeset(%__MODULE__{} = session, %{} = params) do
    session
    |> cast(params, [:token, :user_id, :valid_until])
    |> validate_required([:token, :user_id, :valid_until])
    |> assoc_constraint(:user)
  end
end
