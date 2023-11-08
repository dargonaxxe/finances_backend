defmodule FinancesBackend do
  @moduledoc """
  Documentation for `FinancesBackend`.
  """

  alias FinancesBackend.Account
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

  @type id :: integer()
  @spec create_account(Money.t(), id(), charlist()) :: {:ok, Account} | {:error, any()}
  def create_account(%Money{} = money, user_id, name) do
    account = %Account{}

    params = %{
      balance: money.amount,
      currency: Money.Currency.number(money.currency),
      user_id: user_id,
      name: name
    }

    changeset = Account.changeset(account, params)
    Repo.insert(changeset)
  end
end
