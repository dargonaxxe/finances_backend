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
end
