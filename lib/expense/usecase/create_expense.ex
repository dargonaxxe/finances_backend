defmodule FinancesBackend.Expense.Usecase.CreateExpense do
  @moduledoc """
  A set of methods, validations and checks that are needed in order to create an expense. 
  """
  alias Finances.Repo
  alias FinancesBackend.Account.Usecase.GetAccount
  alias FinancesBackend.Budget.Usecase.GetBudget
  alias FinancesBackend.Expense
  alias FinancesBackend.Account
  alias FinancesBackend.Budget
  import Ecto.Changeset, only: [change: 2]

  defp create_expense(%Budget{} = budget, %Account{} = account, %Date{} = date, amount, comment) do
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
        expense = %Expense{}

        params = %{
          account_id: account.id,
          budget_id: budget.id,
          amount: amount,
          date: date,
          comment: comment
        }

        changeset = Expense.changeset(expense, params)

        try do
          Repo.transaction(fn repo ->
            repo.update!(change(account, balance: account.balance - amount))
            repo.insert!(changeset)
          end)
        rescue
          e in Ecto.InvalidChangesetError -> {:error, e}
        end
    end
  end

  @type id() :: integer()
  @spec execute(id(), id(), Date.t(), integer(), charlist()) :: {:ok, Expense} | {:error, any()}
  def execute(budget_id, account_id, %Date{} = date, amount, comment) do
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
