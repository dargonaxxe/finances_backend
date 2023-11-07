defmodule FinancesBackend do
  @moduledoc """
  Documentation for `FinancesBackend`.
  """

  alias FinancesBackend.Session.Usecase.CreateSession
  alias FinancesBackend.User.Usecase.ValidatePassword
  alias Finances.Repo
  alias FinancesBackend.User

  def sign_up(username, password) do
    changeset =
      User.changeset(
        %User{},
        %{username: username, password: password}
      )

    case changeset do
      {:ok, changeset} ->
        Repo.insert(changeset)

      error ->
        error
    end
  end

  def sign_in(username, password) do
    result = ValidatePassword.execute(username, password)

    case result do
      {:ok, user_id} ->
        CreateSession.execute(user_id)

      error ->
        error
    end
  end
end
