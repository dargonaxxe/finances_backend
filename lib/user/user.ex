defmodule FinancesBackend.User do
  @moduledoc """
  User ecto schema module. Contains regular changeset/2 method 
  has 3 fields: :username, :password, :salt. Password should contain salt+actual password and should be hashed by password hash function. 
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field(:username, :string)
    field(:password, :string)
    field(:pwd_string, :string, virtual: true, redact: true)
    field(:salt, :string)
    timestamps()
  end

  @username_min_length 6
  @pwd_min_length 12
  def changeset(user, attrs = %{username: _, password: password}) do
    salt = Bcrypt.Base.gen_salt()
    hash = Bcrypt.Base.hash_password(password, salt)

    attrs =
      attrs
      |> Map.put(:salt, salt)
      |> Map.put(:password, hash)
      |> Map.put(:pwd_string, password)

    result =
      user
      |> cast(attrs, [:username, :password, :salt, :pwd_string])
      |> validate_length(:pwd_string, min: @pwd_min_length)
      |> validate_length(:username, min: @username_min_length)
      |> unique_constraint(:username)

    {:ok, result}
  end

  def changeset(_, _), do: {:error, :missing_fields}
end
