ExUnit.start()

defmodule FinancesBackend.GetAccountsTest do
  use FinancesBackend.RepoCase

  test "should return empty list when there is no accounts" do
    [] = FinancesBackend.get_accounts(1)
  end

  @money Money.new(123, "USD")
  test "should return all accounts that belong to a given user" do
    {:ok, user} = FinancesBackend.sign_up("username", "passpasspass")
    {:ok, account_1} = FinancesBackend.create_account(@money, user.id, "name-1")
    {:ok, account_2} = FinancesBackend.create_account(@money, user.id, "name-2")

    [^account_1, ^account_2] = FinancesBackend.get_accounts(user.id)
  end

  test "should return only accounts that belong to given user" do
    {:ok, user_1} = FinancesBackend.sign_up("username_1", "passpasspass")
    {:ok, user_2} = FinancesBackend.sign_up("username_2", "passpasspass")
    {:ok, account_1} = FinancesBackend.create_account(@money, user_1.id, "account-name-1")
    {:ok, account_2} = FinancesBackend.create_account(@money, user_2.id, "account-name-2")
    [^account_1] = FinancesBackend.get_accounts(user_1.id)
    [^account_2] = FinancesBackend.get_accounts(user_2.id)
  end
end
