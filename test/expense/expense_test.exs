ExUnit.start()

defmodule FinancesBackend.ExpenseTest do
  alias FinancesBackend.Expense
  use ExUnit.Case

  @expected_fields [
    :id,
    :budget_id,
    :account_id,
    :date,
    :amount,
    :comment,
    :inserted_at,
    :updated_at
  ]
  test "should have expected fields" do
    actual_fields = Expense.__schema__(:fields)
    assert MapSet.new(@expected_fields) == MapSet.new(actual_fields)
  end

  alias FinancesBackend.Expense
  @date Date.from_iso8601!("2023-01-01")
  test "should require budget_id" do
    expense = %Expense{}

    params = %{
      account_id: 0,
      date: @date,
      amount: 1
    }

    changeset = Expense.changeset(expense, params)
    assert !changeset.valid?
    [budget_id: {_, [validation: :required]}] = changeset.errors
  end

  test "should require account_id field" do
    expense = %Expense{}

    params = %{
      budget_id: 0,
      date: @date,
      amount: 1
    }

    changeset = Expense.changeset(expense, params)
    assert !changeset.valid?
    [account_id: {_, [validation: :required]}] = changeset.errors
  end

  test "should require date field" do
    expense = %Expense{}

    params = %{
      account_id: 0,
      budget_id: 1,
      amount: 2
    }

    changeset = Expense.changeset(expense, params)
    assert !changeset.valid?
    [date: {_, [validation: :required]}] = changeset.errors
  end

  test "should require amount field" do
    expense = %Expense{}

    params = %{
      account_id: 0,
      budget_id: 1,
      date: @date
    }

    changeset = Expense.changeset(expense, params)
    assert !changeset.valid?
    [amount: {_, [validation: :required]}] = changeset.errors
  end

  test "should return no error without comment" do
    expense = %Expense{}

    params = %{
      account_id: 0,
      budget_id: 1,
      date: @date,
      amount: 2
    }

    changeset = Expense.changeset(expense, params)
    assert changeset.valid?
  end

  test "should return no error with comment" do
    expense = %Expense{}

    params = %{
      account_id: 0,
      budget_id: 1,
      date: @date,
      amount: 2,
      comment: "comment"
    }

    changeset = Expense.changeset(expense, params)
    assert changeset.valid?
  end
end
