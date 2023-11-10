ExUnit.start()

defmodule FinancesBackend.IncomeTest do
  alias FinancesBackend.Income
  use ExUnit.Case

  @expected_fields [:id, :account_id, :amount, :comment, :inserted_at, :updated_at]
  test "should have expected fields" do
    actual_fields = Income.__schema__(:fields)
    assert MapSet.new(@expected_fields) == MapSet.new(actual_fields)
  end

  test "should require account_id field" do
    income = %Income{}

    params = %{
      account_id: nil,
      amount: 123
    }

    changeset = Income.changeset(income, params)
    [account_id: {_, [validation: :required]}] = changeset.errors
  end

  test "should require amount field" do
    income = %Income{}

    params = %{
      account_id: 1,
      amount: nil
    }

    changeset = Income.changeset(income, params)
    [amount: {_, [validation: :required]}] = changeset.errors
  end
end
