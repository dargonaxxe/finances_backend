defmodule FinancesBackend do
  @moduledoc """
  Documentation for `FinancesBackend`.
  """

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
end
