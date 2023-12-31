defmodule FinancesBackend do
  @moduledoc """
  Documentation for `FinancesBackend`.
  """

  alias FinancesBackend.Expense.Usecase.GetExpensesByDates
  alias FinancesBackend.Budget.Usecase.GetBudgets
  alias FinancesBackend.Account.Usecase.GetAccounts
  alias FinancesBackend.Expense
  alias FinancesBackend.Expense.Usecase.GetExpenses
  alias FinancesBackend.Income.Usecase.CreateIncome
  alias FinancesBackend.Expense.Usecase.CreateExpense
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

  def create_expense(budget_id, account_id, date, amount, comment) do
    CreateExpense.execute(budget_id, account_id, date, amount, comment)
  end

  def create_income(account_id, amount, comment, %Date{} = date) do
    CreateIncome.execute(account_id, amount, comment, date)
  end

  @spec get_expenses(id(), Date.t()) :: list(Expense)
  def get_expenses(budget_id, %Date{} = date) do
    GetExpenses.execute(budget_id, date)
  end

  @spec get_accounts(id()) :: list(Account)
  def get_accounts(user_id) do
    GetAccounts.execute(user_id)
  end

  def get_budgets(user_id) do
    GetBudgets.execute(user_id)
  end

  def get_expenses_by_dates(budget_id) do
    GetExpensesByDates.execute(budget_id)
  end
end
