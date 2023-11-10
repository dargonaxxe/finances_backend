ExUnit.start()

defmodule FinancesBackend.ExpenseRepoTest do
  use FinancesBackend.RepoCase

  alias FinancesBackend.Expense
  @money Money.new(123, "usd")
  @date Date.from_iso8601!("2023-01-01")
  test "should validate budget existence" do
    {:ok, user} = FinancesBackend.sign_up("username", "passpasspass")
    {:ok, account} = FinancesBackend.create_account(@money, user.id, "name")

    expense = %Expense{}

    params = %{
      budget_id: 0,
      account_id: account.id,
      date: @date,
      amount: 123
    }

    changeset = Expense.changeset(expense, params)
    {:error, reason} = Repo.insert(changeset)
    [budget: {_, [constraint: :assoc, constraint_name: _]}] = reason.errors
  end

  @start_date @date
  @end_date Date.from_iso8601!("2024-01-01")
  test "should validate account existence" do
    {:ok, user} = FinancesBackend.sign_up("username", "passpasspass")
    {:ok, budget} = FinancesBackend.create_budget(@money, user.id, "name", @start_date, @end_date)
    expense = %Expense{}

    params = %{
      budget_id: budget.id,
      account_id: 0,
      date: @date,
      amount: 123
    }

    changeset = Expense.changeset(expense, params)
    {:error, reason} = Repo.insert(changeset)
    [account: {_, [constraint: :assoc, constraint_name: _]}] = reason.errors
  end

  test "should validate amount" do
    {:ok, user} = FinancesBackend.sign_up("username", "passpasspass")
    {:ok, account} = FinancesBackend.create_account(@money, user.id, "account-name")

    {:ok, budget} =
      FinancesBackend.create_budget(@money, user.id, "budget-name", @start_date, @end_date)

    expense = %Expense{}

    params = %{
      account_id: account.id,
      budget_id: budget.id,
      date: @date,
      amount: -1
    }

    changeset = Expense.changeset(expense, params)
    {:error, reason} = Repo.insert(changeset)

    [amount: {_, [constraint: :check, constraint_name: "amount_should_be_positive"]}] =
      reason.errors
  end

  test "should have no error without comment" do
    {:ok, user} = FinancesBackend.sign_up("username", "passpasspass")

    {:ok, budget} =
      FinancesBackend.create_budget(@money, user.id, "budget-name", @start_date, @end_date)

    {:ok, account} = FinancesBackend.create_account(@money, user.id, "account-name")
    expense = %Expense{}

    params = %{
      account_id: account.id,
      budget_id: budget.id,
      date: @date,
      amount: 123
    }

    changeset = Expense.changeset(expense, params)
    {:ok, result} = Repo.insert(changeset)
    assert result.account_id == account.id
    assert result.budget_id == budget.id
    assert result.date == @date
    assert result.amount == 123
    assert result.comment == nil
  end

  test "should have no error with comment" do
    {:ok, user} = FinancesBackend.sign_up("username", "passpasspass")
    {:ok, account} = FinancesBackend.create_account(@money, user.id, "account-name")

    {:ok, budget} =
      FinancesBackend.create_budget(@money, user.id, "budget-name", @start_date, @end_date)

    expense = %Expense{}

    params = %{
      account_id: account.id,
      budget_id: budget.id,
      date: @date,
      amount: 123,
      comment: "comment"
    }

    changeset = Expense.changeset(expense, params)
    {:ok, result} = Repo.insert(changeset)
    assert result.account_id == account.id
    assert result.budget_id == budget.id
    assert result.date == @date
    assert result.amount == 123
    assert result.comment == "comment"
  end
end
