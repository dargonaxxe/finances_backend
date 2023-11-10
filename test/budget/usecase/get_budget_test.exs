ExUnit.start()

defmodule FinancesBackend.Budget.Usecase.GetBudgetTest do
  alias FinancesBackend.Budget.Usecase.GetBudget
  use FinancesBackend.RepoCase

  test "should return nil when budget does not exist" do
    nil = GetBudget.execute(1)
  end

  test "should return the budget when it exist" do
    {:ok, user} = FinancesBackend.sign_up("username", "passpasspass")

    {:ok, budget} =
      FinancesBackend.create_budget(
        Money.new(123, "USD"),
        user.id,
        "budget-name",
        Date.from_iso8601!("2023-01-01"),
        Date.from_iso8601!("2024-01-01")
      )

    result = GetBudget.execute(budget.id)
    assert result == budget
  end
end
