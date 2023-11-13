ExUnit.start()

defmodule FinancesBackend.Account.Usecase.GetAccountTest do
  alias FinancesBackend.Account.Usecase.GetAccount
  use FinancesBackend.RepoCase

  test "should return nil when account does not exist" do
    nil = GetAccount.execute(1)
  end

  test "should return an account when one exist" do
    {:ok, user} = FinancesBackend.sign_up("username", "passpasspass")

    {:ok, account_one} =
      FinancesBackend.create_account(Money.new(123, "USD"), user.id, "account-name")

    account_two = GetAccount.execute(account_one.id)
    assert account_two == account_one
  end
end
