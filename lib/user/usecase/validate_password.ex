defmodule FinancesBackend.User.Usecase.ValidatePassword do
  @moduledoc """
  Usecase to validate user password. Used as a part of sign-in scenario and when user wants to change their password. 
  """
  alias FinancesBackend.User

  @spec execute(charlist(), charlist()) :: :ok | {:error, :invalid_credentials}
  def execute(username, password) do
    user = Finances.Repo.get_by(FinancesBackend.User, username: username)

    case user do
      nil ->
        {:error, :invalid_credentials}

      user ->
        validate_password(user, password)
    end
  end

  @spec validate_password(User, charlist()) :: :ok | {:error, :invalid_credentials}
  defp validate_password(%User{} = user, password) do
    valid? = Bcrypt.verify_pass(password, user.password)

    if valid? do
      :ok
    else
      {:error, :invalid_credentials}
    end
  end
end
