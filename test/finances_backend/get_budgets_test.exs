ExUnit.start()

defmodule FinancesBackend.GetBudgetsTest do
  use FinancesBackend.RepoCase

  test "should return empty list when there's nothing to return" do
    [] = FinancesBackend.get_budgets(1)
  end

  @money Money.new(123, "USD")
  @date_start ~D"2023-01-01"
  @date_end ~D"2024-01-01"
  test "should return every budget that belongs to user" do
    {:ok, user} = FinancesBackend.sign_up("username", "passpasspass")

    {:ok, budget_1} =
      FinancesBackend.create_budget(@money, user.id, "budget-name-1", @date_start, @date_end)

    {:ok, budget_2} =
      FinancesBackend.create_budget(@money, user.id, "budget-name-2", @date_start, @date_end)

    [^budget_1, ^budget_2] = FinancesBackend.get_budgets(user.id)
  end

  test "should only return budget that belong to given user" do
    {:ok, user_1} = FinancesBackend.sign_up("username-1", "passpasspass")
    {:ok, user_2} = FinancesBackend.sign_up("username-2", "passpasspass")

    {:ok, budget_1} =
      FinancesBackend.create_budget(@money, user_1.id, "budget-1", @date_start, @date_end)

    {:ok, budget_2} =
      FinancesBackend.create_budget(@money, user_2.id, "budget-2", @date_start, @date_end)

    [^budget_1] = FinancesBackend.get_budgets(user_1.id)
    [^budget_2] = FinancesBackend.get_budgets(user_2.id)
  end
end
