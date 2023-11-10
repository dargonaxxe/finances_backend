defmodule FinancesBackend.Expense.Usecase.CreateExpense do
  @moduledoc """
  A set of methods, validations and checks that are needed in order to create an expense. 
  """
  alias Ecto.Changeset
  alias Finances.Repo
  alias FinancesBackend.Account.Usecase.WithAccount
  alias FinancesBackend.Budget.Usecase.GetBudget
  alias FinancesBackend.Expense
  alias FinancesBackend.Account
  alias FinancesBackend.Budget
  import Ecto.Changeset, only: [change: 2]

  @type id() :: integer()
  @spec execute(id(), id(), Date.t(), integer(), charlist()) :: {:ok, Expense} | {:error, any()}
  def execute(budget_id, account_id, %Date{} = date, amount, comment) do
    with_budget(budget_id, fn budget ->
      WithAccount.execute(account_id, fn account ->
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

  defp create_expense(%Budget{} = budget, %Account{} = account, %Date{} = date, amount, comment) do
    case validate_expense(budget, account, date, amount) do
      :ok ->
        build_changeset(budget, account, date, amount, comment)
        |> process_transaction(account)

      error ->
        error
    end
  end

  defp validate_expense(%Budget{} = budget, %Account{} = account, %Date{} = date, amount) do
    cond do
      budget.user_id != account.user_id ->
        {:error, :budget_and_account_belong_to_different_users}

      Date.before?(date, budget.start_date) || Date.before?(budget.end_date, date) ->
        {:error,
         {:date_is_out_of_budget, date: date, start: budget.start_date, end: budget.end_date}}

      amount > account.balance ->
        {:error, {:insufficient_balance, balance: account.balance, amount: amount}}

      budget.currency != account.currency ->
        {:error,
         {:account_currency_differs_from_budget,
          account_currency: account.currency, budget_currency: budget.currency}}

      true ->
        :ok
    end
  end

  defp build_changeset(%Budget{} = budget, %Account{} = account, %Date{} = date, amount, comment) do
    expense = %Expense{}

    params = %{
      account_id: account.id,
      budget_id: budget.id,
      amount: amount,
      date: date,
      comment: comment
    }

    Expense.changeset(expense, params)
  end

  defp process_transaction(%Changeset{} = changeset, %Account{} = account) do
    try do
      Repo.transaction(fn repo ->
        balance = account.balance - changeset.changes.amount

        change(account, balance: balance)
        |> repo.update!()

        changeset
        |> repo.insert!()
      end)
    rescue
      e in Ecto.InvalidChangesetError -> {:error, e}
    end
  end
end
