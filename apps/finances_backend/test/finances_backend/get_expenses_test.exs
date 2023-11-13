ExUnit.start()

defmodule FinancesBackend.GetExpensesTest do
  use FinancesBackend.RepoCase

  test "should return an empty list when there's nothing to return" do
    [] = FinancesBackend.get_expenses(0, ~D"2023-01-01")
  end

  @amount 123
  @money Money.new(@amount, "USD")
  @date_start ~D"2023-01-01"
  @date_end ~D"2024-01-01"
  test "should return an expense when present" do
    {:ok, user} = FinancesBackend.sign_up("username", "passpasspass")

    {:ok, budget} =
      FinancesBackend.create_budget(@money, user.id, "budget-name", @date_start, @date_end)

    {:ok, account} = FinancesBackend.create_account(@money, user.id, "account-name")
    date = @date_start

    {:ok, expense} =
      FinancesBackend.create_expense(budget.id, account.id, date, @amount, "comment")

    [^expense] = FinancesBackend.get_expenses(budget.id, date)
  end

  test "should return expenses that only belong to this budget" do
    {:ok, user} = FinancesBackend.sign_up("username", "passpasspass")

    {:ok, budget_1} =
      FinancesBackend.create_budget(@money, user.id, "budget-one", @date_start, @date_end)

    {:ok, budget_2} =
      FinancesBackend.create_budget(@money, user.id, "budget-two", @date_start, @date_end)

    {:ok, account} = FinancesBackend.create_account(@money, user.id, "account")

    {:ok, expense_1} =
      FinancesBackend.create_expense(budget_1.id, account.id, @date_start, 1, "comment-1")

    {:ok, expense_2} =
      FinancesBackend.create_expense(budget_2.id, account.id, @date_start, 1, "comment-2")

    [^expense_1] = FinancesBackend.get_expenses(budget_1.id, @date_start)
    [^expense_2] = FinancesBackend.get_expenses(budget_2.id, @date_start)
  end

  test "should only return expense that belong to given date" do
    {:ok, user} = FinancesBackend.sign_up("username", "passpasspass")

    {:ok, budget} =
      FinancesBackend.create_budget(@money, user.id, "budget-name", @date_start, @date_end)

    {:ok, account} = FinancesBackend.create_account(@money, user.id, "account-name")

    {:ok, expense_1} =
      FinancesBackend.create_expense(budget.id, account.id, @date_start, 1, "comment-1")

    {:ok, expense_2} =
      FinancesBackend.create_expense(budget.id, account.id, @date_end, 1, "comment-2")

    [^expense_1] = FinancesBackend.get_expenses(budget.id, @date_start)
    [^expense_2] = FinancesBackend.get_expenses(budget.id, @date_end)
  end
end
