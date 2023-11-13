ExUnit.start()

defmodule FinancesBackend.BudgetTest do
  alias FinancesBackend.Budget

  use ExUnit.Case

  @expected_fields [
    :id,
    :name,
    :user_id,
    :allocated_money,
    :currency,
    :start_date,
    :end_date,
    :inserted_at,
    :updated_at,
    :daily_prognosis
  ]
  test "should consist of expected fields" do
    actual_fields = Budget.__schema__(:fields)
    assert MapSet.new(@expected_fields) == MapSet.new(actual_fields)
  end

  @date Date.from_iso8601!("2023-01-01")
  test "should require name field" do
    budget = %Budget{}

    params = %{
      user_id: 0,
      allocated_money: 1,
      currency: 2,
      start_date: @date,
      end_date: @date
    }

    changeset = Budget.changeset(budget, params)
    assert !changeset.valid?
    [name: {_, [validation: :required]}] = changeset.errors
  end

  test "should require user_id field" do
    budget = %Budget{}

    params = %{
      name: "name",
      allocated_money: 0,
      currency: 1,
      start_date: @date,
      end_date: @date
    }

    changeset = Budget.changeset(budget, params)
    assert !changeset.valid?

    [user_id: {_, [validation: :required]}] = changeset.errors
  end

  test "should require allocated_money field" do
    budget = %Budget{}

    params = %{
      name: "name",
      user_id: 0,
      currency: 1,
      start_date: @date,
      end_date: @date
    }

    changeset = Budget.changeset(budget, params)
    assert !changeset.valid?
    [allocated_money: {_, [validation: :required]}] = changeset.errors
  end

  test "should require currency field" do
    budget = %Budget{}

    params = %{
      name: "name",
      user_id: 0,
      allocated_money: 1,
      start_date: @date,
      end_date: @date
    }

    changeset = Budget.changeset(budget, params)
    assert !changeset.valid?
    [currency: {_, [validation: :required]}] = changeset.errors
  end

  test "should require start_date field" do
    budget = %Budget{}

    params = %{
      name: "name",
      user_id: 0,
      allocated_money: 1,
      currency: 1,
      end_date: @date
    }

    changeset = Budget.changeset(budget, params)
    assert !changeset.valid?
    [start_date: {_, [validation: :required]}] = changeset.errors
  end

  test "should require end_date field" do
    budget = %Budget{}

    params = %{
      name: "name",
      user_id: 0,
      allocated_money: 1,
      currency: 2,
      start_date: @date
    }

    changeset = Budget.changeset(budget, params)
    assert !changeset.valid?
    [end_date: {_, [validation: :required]}] = changeset.errors
  end

  test "should validate name length" do
    budget = %Budget{}

    params = %{
      name: "na",
      user_id: 0,
      allocated_money: 1,
      currency: 2,
      start_date: @date,
      end_date: @date
    }

    changeset = Budget.changeset(budget, params)
    assert !changeset.valid?
    [name: {_, [count: 3, validation: :length, kind: :min, type: :string]}] = changeset.errors
  end
end
