ExUnit.start()

defmodule FinancesBackend.AccountTest do
  alias FinancesBackend.Account

  use ExUnit.Case

  @expected_fields [:id, :balance, :currency, :user_id, :name, :updated_at, :inserted_at]
  test "should have expected fields" do
    actual_fields = Account.__schema__(:fields)
    assert MapSet.new(@expected_fields) == MapSet.new(actual_fields)
  end

  test "should require balance" do
    account = %Account{}

    params = %{
      currency: 0,
      user_id: 1,
      name: "name"
    }

    changeset = Account.changeset(account, params)
    assert !changeset.valid?
    [balance: {_, [validation: :required]}] = changeset.errors
  end

  test "should require currency" do
    account = %Account{}

    params = %{
      balance: 0,
      user_id: 1,
      name: "name"
    }

    changeset = Account.changeset(account, params)
    assert !changeset.valid?
    [currency: {_, [validation: :required]}] = changeset.errors
  end

  test "should requrie user_id" do
    account = %Account{}

    params = %{
      balance: 0,
      currency: 1,
      name: "name"
    }

    changeset = Account.changeset(account, params)
    assert !changeset.valid?
    [user_id: {_, [validation: :required]}] = changeset.errors
  end

  test "should require name" do
    account = %Account{}

    params = %{
      balance: 0,
      currency: 1,
      user_id: 2
    }

    changeset = Account.changeset(account, params)
    assert !changeset.valid?
    [name: {_, [validation: :required]}] = changeset.errors
  end

  test "should validate name length" do
    account = %Account{}

    params = %{
      balance: 0,
      currency: 1,
      user_id: 2,
      name: "12"
    }

    changeset = Account.changeset(account, params)
    assert !changeset.valid?
    [name: {_, [count: 3, validation: :length, kind: :min, type: :string]}] = changeset.errors
  end

  test "should return no errors" do
    account = %Account{}

    params = %{
      balance: 0,
      currency: 1,
      user_id: 2,
      name: "123"
    }

    changeset = Account.changeset(account, params)
    assert changeset.valid?
  end
end
