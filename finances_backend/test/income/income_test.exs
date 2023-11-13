ExUnit.start()

defmodule FinancesBackend.IncomeTest do
  alias FinancesBackend.Income
  use ExUnit.Case

  @expected_fields [:id, :account_id, :amount, :comment, :inserted_at, :updated_at, :date]
  test "should have expected fields" do
    actual_fields = Income.__schema__(:fields)
    assert MapSet.new(@expected_fields) == MapSet.new(actual_fields)
  end

  @date Date.from_iso8601!("2023-01-01")
  test "should require account_id field" do
    income = %Income{}

    params = %{
      account_id: nil,
      amount: 123,
      date: @date
    }

    changeset = Income.changeset(income, params)
    [account_id: {_, [validation: :required]}] = changeset.errors
  end

  test "should require amount field" do
    income = %Income{}

    params = %{
      account_id: 1,
      amount: nil,
      date: @date
    }

    changeset = Income.changeset(income, params)
    [amount: {_, [validation: :required]}] = changeset.errors
  end

  test "should require date field" do
    params = %{
      account_id: 1,
      amount: 2,
      date: nil
    }

    changeset =
      %Income{}
      |> Income.changeset(params)

    assert !changeset.valid?
    [date: {_, [validation: :required]}] = changeset.errors
  end

  test "should return valid changeset with comment" do
    params = %{
      account_id: 1,
      amount: 2,
      date: @date,
      comment: "comment"
    }

    changeset = %Income{} |> Income.changeset(params)
    assert changeset.valid?
  end

  test "should return valid changeset without comment" do
    params = %{
      account_id: 1,
      amount: 2,
      date: @date,
      comment: nil
    }

    changeset = %Income{} |> Income.changeset(params)
    assert changeset.valid?
  end
end
