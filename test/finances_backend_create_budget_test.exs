ExUnit.start()

defmodule FinancesBackend.CreateBudgetTest do
  use FinancesBackend.RepoCase

  @start_date Date.from_iso8601!("2023-01-01")
  @end_date Date.from_iso8601!("2024-01-01")
  test "should validate money type for the first argument" do
    assert_raise FunctionClauseError, fn ->
      FinancesBackend.create_budget("12$", 12, "name", @start_date, @end_date)
    end
  end

  @money Money.new(123, "usd")
  test "should validate date type for 4th argument" do
    assert_raise FunctionClauseError, fn ->
      FinancesBackend.create_budget(@money, 1, "name", "2023-01-01", @end_date)
    end
  end

  test "should validate date type for 5th argument" do
    assert_raise FunctionClauseError, fn ->
      FinancesBackend.create_budget(@money, 1, "name", @start_date, "2024-01-01")
    end
  end

  test "should validate user existence" do
    {:error, reason} = FinancesBackend.create_budget(@money, 123, "name", @start_date, @end_date)
    [user: {_, [constraint: :assoc, constraint_name: _]}] = reason.errors
  end

  test "should validate money" do
    {:ok, user} = FinancesBackend.sign_up("username", "passpasspass")

    {:error, reason} =
      FinancesBackend.create_budget(
        Money.new(-123, "usd"),
        user.id,
        "name",
        @start_date,
        @end_date
      )

    [
      allocated_money:
        {_, [constraint: :check, constraint_name: "allocated_money_should_be_positive"]}
    ] = reason.errors
  end

  test "should validate name" do
    {:ok, user} = FinancesBackend.sign_up("username", "passpasspass")

    {:error, reason} =
      FinancesBackend.create_budget(@money, user.id, "na", @start_date, @end_date)

    [name: {_, [count: 3, validation: :length, kind: :min, type: :string]}] = reason.errors
  end

  test "should validate start_date" do
    {:ok, user} = FinancesBackend.sign_up("username", "passpasspass")

    {:error, reason} =
      FinancesBackend.create_budget(@money, user.id, "name", @start_date, @start_date)

    [start_date: {_, [constraint: :check, constraint_name: "budget_should_start_before_end"]}] =
      reason.errors
  end

  test "should return no error" do
    {:ok, user} = FinancesBackend.sign_up("username", "passpasspass")
    {:ok, budget} = FinancesBackend.create_budget(@money, user.id, "name", @start_date, @end_date)
    assert budget.name == "name"
    assert budget.user_id == user.id
    assert budget.start_date == @start_date
    assert budget.end_date == @end_date
    assert budget.allocated_money == @money.amount
    assert budget.currency == Money.Currency.number(@money.currency)
  end
end
