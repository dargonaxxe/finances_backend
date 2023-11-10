ExUnit.start()

defmodule FinancesBackend.CreateIncomeTest do
  alias FinancesBackend.Account.Usecase.GetAccount
  use FinancesBackend.RepoCase
  alias FinancesBackend.Account

  @money_account Money.new(123, "USD")
  @amount_income 321
  @date Date.from_iso8601!("2023-01-01")
  test "should return no error with comment and change account balance" do
    {:ok, user} = FinancesBackend.sign_up("username", "passpasspass")
    {:ok, account} = FinancesBackend.create_account(@money_account, user.id, "account-name")
    {:ok, income} = FinancesBackend.create_income(account.id, @amount_income, "comment", @date)
    %Account{} = account_updated = GetAccount.execute(account.id)
    assert income.account_id == account.id
    assert income.amount == @amount_income
    assert income.comment == "comment"
    assert income.date == @date
    assert account_updated.balance == account.balance + income.amount
  end

  test "should return no error without comment and change account balance" do
    {:ok, user} = FinancesBackend.sign_up("username", "passpasspass")
    {:ok, account} = FinancesBackend.create_account(@money_account, user.id, "account-name")
    {:ok, income} = FinancesBackend.create_income(account.id, @amount_income, nil, @date)
    %Account{} = account_updated = GetAccount.execute(account.id)
    assert income.account_id == account.id
    assert income.amount == @amount_income
    assert income.comment == nil
    assert income.date == @date
    assert account_updated.balance == account.balance + income.amount
  end

  test "should validate account existence " do
    {:error, {:invalid_account_id, 1}} =
      FinancesBackend.create_income(1, @amount_income, nil, @date)
  end

  test "should validate check that income amount is positive" do
    {:ok, user} = FinancesBackend.sign_up("username", "passpasspass")
    {:ok, account} = FinancesBackend.create_account(@money_account, user.id, "account-name")
    {:error, reason} = FinancesBackend.create_income(account.id, 0, nil, @date)

    [amount: {_, [constraint: :check, constraint_name: "income_amount_should_be_positive"]}] =
      reason.changeset.errors
  end
end
