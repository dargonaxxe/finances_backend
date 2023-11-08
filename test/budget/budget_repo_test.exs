ExUnit.start()

defmodule FinancesBackend.BudgetRepoTest do
  use FinancesBackend.RepoCase

  alias FinancesBackend.Budget
  @start_date Date.from_iso8601!("2023-01-01")
  @end_date Date.from_iso8601!("2024-01-01")
  test "should check user existence" do
    budget = %Budget{}

    params = %{
      name: "name",
      user_id: 0,
      allocated_money: 1,
      currency: 2,
      start_date: @start_date,
      end_date: @end_date
    }

    changeset = Budget.changeset(budget, params)
    {:error, reason} = Repo.insert(changeset)
    [user: {_, [constraint: :assoc, constraint_name: _]}] = reason.errors
  end

  test "should check allocated money is positive" do
    {:ok, user} = FinancesBackend.sign_up("username", "passpasspass")
    budget = %Budget{}

    params = %{
      name: "name",
      user_id: user.id,
      allocated_money: -1,
      currency: 2,
      start_date: @start_date,
      end_date: @end_date
    }

    changeset = Budget.changeset(budget, params)
    {:error, reason} = Repo.insert(changeset)

    [
      allocated_money:
        {_, [constraint: :check, constraint_name: "allocated_money_should_be_positive"]}
    ] = reason.errors
  end

  test "should check start date is before end date" do
    {:ok, user} = FinancesBackend.sign_up("username", "passpasspass")
    budget = %Budget{}

    params = %{
      name: "name",
      user_id: user.id,
      allocated_money: 1,
      currency: 2,
      start_date: @start_date,
      end_date: @start_date
    }

    changeset = Budget.changeset(budget, params)
    {:error, reason} = Repo.insert(changeset)

    [start_date: {_, [constraint: :check, constraint_name: "budget_should_start_before_end"]}] =
      reason.errors
  end

  test "should return no error" do
    {:ok, user} = FinancesBackend.sign_up("username", "passpasspass")
    budget = %Budget{}

    params = %{
      name: "name",
      user_id: user.id,
      allocated_money: 1,
      currency: 2,
      start_date: @start_date,
      end_date: @end_date
    }

    changeset = Budget.changeset(budget, params)
    {:ok, result} = Repo.insert(changeset)
    assert result.name == "name"
    assert result.user_id == user.id
    assert result.allocated_money == 1
    assert result.currency == 2
    assert result.start_date == @start_date
    assert result.end_date == @end_date
  end
end
