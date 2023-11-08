ExUnit.start()

defmodule FinancesBackend.AccountRepoTest do
  use FinancesBackend.RepoCase

  alias FinancesBackend.Account

  test "should check user existence" do
    account = %Account{}

    params = %{
      balance: 0,
      currency: 1,
      user_id: 2,
      name: "123"
    }

    changeset = Account.changeset(account, params)
    {:error, reason} = Repo.insert(changeset)
    [user: {_, [constraint: :assoc, constraint_name: _]}] = reason.errors
  end

  test "should return no error" do
    {:ok, user} = FinancesBackend.sign_up("username", "passpasspass")
    account = %Account{}

    params = %{
      balance: 0,
      currency: 1,
      user_id: user.id,
      name: "123"
    }

    changeset = Account.changeset(account, params)
    {:ok, account} = Repo.insert(changeset)
    assert account.user_id == user.id
    assert account.name == "123"
    assert account.currency == 1
    assert account.balance == 0
  end
end
