defmodule FinancesBackend do
  @moduledoc """
  Documentation for `FinancesBackend`.
  """

  alias FinancesBackend.Expense
  alias FinancesBackend.Account.Usecase.GetAccount
  alias FinancesBackend.Budget.Usecase.GetBudget
  alias FinancesBackend.Budget
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

  @spec create_budget(Money.t(), id(), charlist(), Date.t(), Date.t()) ::
          {:ok, Budget} | {:error, any()}
  def create_budget(%Money{} = money, user_id, name, %Date{} = start_date, %Date{} = end_date) do
    budget = %Budget{}

    params = %{
      name: name,
      user_id: user_id,
      allocated_money: money.amount,
      currency: Money.Currency.number(money.currency),
      start_date: start_date,
      end_date: end_date
    }

    changeset = Budget.changeset(budget, params)
    Repo.insert(changeset)
  end

  import Ecto.Changeset, only: [change: 2]

  def create_expense(%Budget{} = budget, %Account{} = account, %Date{} = date, amount, comment) do
    cond do
      budget.user_id != account.user_id ->
        {:error, :budget_and_account_belong_to_different_users}

      Date.before?(budget.start_date, date) || Date.before?(budget.end_date, date) ->
        {:error,
         {:date_is_out_of_budget, date: date, start: budget.start_date, end: budget.end_date}}

      amount > account.balance ->
        {:error, {:insufficient_balance, balance: account.balance, amount: amount}}

      budget.currency != account.currency ->
        {:error,
         {:account_currency_differs_from_budget,
          account_currency: account.currency, budget_currency: budget.currency}}

      true ->
        expense = %Expense{}

        params = %{
          account_id: account.id,
          budget_id: budget.id,
          amount: amount,
          date: date,
          comment: comment
        }

        changeset = Expense.changeset(expense, params)

        Repo.transaction(fn repo ->
          repo.insert!(changeset)
          repo.update!(change(account, balance: account.balance - amount))
        end)
    end
  end

  def create_expense(budget_id, account_id, %Date{} = date, amount, comment) do
    with_budget(budget_id, fn budget ->
      with_account(account_id, fn account ->
        create_expense(budget, account, date, amount, comment)
      end)
    end)
  end

  defp with_budget(budget_id, lambda) do
    case GetBudget.execute(budget_id) do
      nil ->
        {:error, {:invalid_budget_id, budget_id}}

      %Budget{} = budget ->
        lambda.(budget)
    end
  end

  defp with_account(account_id, lambda) do
    case GetAccount.execute(account_id) do
      nil ->
        {:error, {:invalid_account_id, account_id}}

      %Account{} = account ->
        lambda.(account)
    end
  end
end
