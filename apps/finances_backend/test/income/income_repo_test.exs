ExUnit.start()

defmodule FinancesBackend.IncomeRepoTest do
  alias FinancesBackend.Income
  use FinancesBackend.RepoCase

  @date Date.from_iso8601!("2023-01-01")
  @money Money.new(123, "USD")
  test "should return no error with comment" do
    {:ok, user} = FinancesBackend.sign_up("username", "passpasspass")
    {:ok, account} = FinancesBackend.create_account(@money, user.id, "account-name")

    income = %Income{}

    params = %{
      account_id: account.id,
      amount: 123,
      comment: "comment",
      date: @date
    }

    changeset = Income.changeset(income, params)
    {:ok, income} = Repo.insert(changeset)
    assert income.account_id == account.id
    assert income.amount == 123
    assert income.comment == "comment"
  end

  test "should return no error without comment" do
    {:ok, user} = FinancesBackend.sign_up("username", "passpasspass")
    {:ok, account} = FinancesBackend.create_account(@money, user.id, "account-name")
    income = %Income{}

    params = %{
      account_id: account.id,
      amount: 123,
      comment: nil,
      date: @date
    }

    changeset = Income.changeset(income, params)
    {:ok, income} = Repo.insert(changeset)
    assert income.account_id == account.id
    assert income.amount == 123
    assert income.comment == nil
  end

  test "should check account existence" do
    income = %Income{}

    params = %{
      account_id: 1,
      amount: 123,
      comment: nil,
      date: @date
    }

    {:error, reason} =
      Income.changeset(income, params)
      |> Repo.insert()

    [account: {_, [constraint: :assoc, constraint_name: _]}] = reason.errors
  end

  test "should check that amount is positive" do
    {:ok, user} = FinancesBackend.sign_up("username", "passpasspass")
    {:ok, account} = FinancesBackend.create_account(@money, user.id, "account-name")

    params = %{
      account_id: account.id,
      amount: 0,
      comment: nil,
      date: @date
    }

    {:error, reason} =
      %Income{}
      |> Income.changeset(params)
      |> Repo.insert()

    [amount: {_, [constraint: :check, constraint_name: "income_amount_should_be_positive"]}] =
      reason.errors
  end
end
