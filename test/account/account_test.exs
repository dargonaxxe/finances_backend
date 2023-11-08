ExUnit.start()

defmodule FinancesBackend.AccountTest do
  alias FinancesBackend.Account

  use ExUnit.Case

  @expected_fields [:id, :balance, :currency, :user_id, :name, :updated_at, :inserted_at]
  test "should have expected fields" do
    actual_fields = Account.__schema__(:fields)
    assert MapSet.new(@expected_fields) == MapSet.new(actual_fields)
  end
end
