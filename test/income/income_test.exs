ExUnit.start()

defmodule FinancesBackend.IncomeTest do
  alias FinancesBackend.Income
  use ExUnit.Case

  @expected_fields [:id, :account_id, :amount, :comment, :inserted_at, :updated_at]
  test "should have expected fields" do
    actual_fields = Income.__schema__(:fields)
    assert MapSet.new(@expected_fields) == MapSet.new(actual_fields)
  end
end
