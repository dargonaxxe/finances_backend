ExUnit.start()

defmodule FinancesBackend.GetExpensesByDatesTest do
  alias FinancesBackend.Expense.Model.ExpensesByDate
  use FinancesBackend.RepoCase

  @money_budget Money.new(123, "USD")
  test "should return what is expected" do
    {:ok, user} = FinancesBackend.sign_up("username", "passpasspass")

    {:ok, budget} =
      FinancesBackend.create_budget(
        @money_budget,
        user.id,
        "budget-name",
        ~D"2023-01-01",
        ~D"2023-01-07"
      )

    {:ok, account} = FinancesBackend.create_account(@money_budget, user.id, "account-name")

    {:ok, expense_1} =
      FinancesBackend.create_expense(budget.id, account.id, ~D"2023-01-01", 1, "comment-1")

    {:ok, expense_2} =
      FinancesBackend.create_expense(budget.id, account.id, ~D"2023-01-02", 2, "comment-2")

    {:ok, expense_3} =
      FinancesBackend.create_expense(budget.id, account.id, ~D"2023-01-03", 3, "comment-3")

    {:ok, expense_4} =
      FinancesBackend.create_expense(budget.id, account.id, ~D"2023-01-04", 4, "comment-4")

    {:ok, expense_5} =
      FinancesBackend.create_expense(budget.id, account.id, ~D"2023-01-05", 5, "comment-5")

    {:ok, expense_6} =
      FinancesBackend.create_expense(budget.id, account.id, ~D"2023-01-06", 6, "comment-6")

    {:ok, expense_7} =
      FinancesBackend.create_expense(budget.id, account.id, ~D"2023-01-07", 7, "comment-7")

    {:ok, expense_8} =
      FinancesBackend.create_expense(budget.id, account.id, ~D"2023-01-07", 8, "comment-8")

    %{
      ~D"2023-01-01" => %ExpensesByDate{
        cumulative_expenses: 1,
        local_expenses: 1,
        budget_proficit: 16,
        expenses: [^expense_1]
      },
      ~D"2023-01-02" => %ExpensesByDate{
        cumulative_expenses: 3,
        local_expenses: 2,
        budget_proficit: 31,
        expenses: [^expense_2]
      },
      ~D"2023-01-03" => %ExpensesByDate{
        cumulative_expenses: 6,
        local_expenses: 3,
        budget_proficit: 45,
        expenses: [^expense_3]
      },
      ~D"2023-01-04" => %ExpensesByDate{
        cumulative_expenses: 10,
        local_expenses: 4,
        budget_proficit: 58,
        expenses: [^expense_4]
      },
      ~D"2023-01-05" => %ExpensesByDate{
        cumulative_expenses: 15,
        local_expenses: 5,
        budget_proficit: 70,
        expenses: [^expense_5]
      },
      ~D"2023-01-06" => %ExpensesByDate{
        cumulative_expenses: 21,
        local_expenses: 6,
        budget_proficit: 81,
        expenses: [^expense_6]
      },
      ~D"2023-01-07" => %ExpensesByDate{
        cumulative_expenses: 36,
        local_expenses: 15,
        budget_proficit: 83,
        expenses: [^expense_7, ^expense_8]
      }
    } = FinancesBackend.get_expenses_by_dates(budget.id)
  end
end
