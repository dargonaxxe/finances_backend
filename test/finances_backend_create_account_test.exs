ExUnit.start()

defmodule FinancesBackend.CreateAccountTest do
  use FinancesBackend.RepoCase

  test "should validate input type for the first argument" do
    assert_raise FunctionClauseError, fn ->
      FinancesBackend.create_account("12$", 123, "name")
    end
  end

  @money Money.new(123, "USD")
  test("should return an error when user does not exist") do
    {:error, reason} =
      FinancesBackend.create_account(
        @money,
        123,
        "name"
      )

    [user: {_, [constraint: :assoc, constraint_name: _]}] = reason.errors
  end

  test "should return an error when name is short" do
    {:ok, user} = FinancesBackend.sign_up("username", "passpasspass")

    {:error, reason} =
      FinancesBackend.create_account(
        @money,
        user.id,
        "na"
      )

    [name: {_, [count: 3, validation: :length, kind: :min, type: :string]}] = reason.errors
  end

  test "should return no error" do
    {:ok, user} = FinancesBackend.sign_up("username", "passpasspass")

    {:ok, account} =
      FinancesBackend.create_account(
        @money,
        user.id,
        "name"
      )

    assert account.balance == @money.amount
    assert account.currency == Money.Currency.number(@money.currency)
    assert account.user_id == user.id
    assert account.name == "name"
  end
end
