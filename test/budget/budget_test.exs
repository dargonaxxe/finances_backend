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
    :updated_at
  ]
  test "should consist of expected fields" do
    actual_fields = Budget.__schema__(:fields)
    assert MapSet.new(@expected_fields) == MapSet.new(actual_fields)
  end
end
