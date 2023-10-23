defmodule FinancesBackendTest do
  use ExUnit.Case
  doctest FinancesBackend

  test "greets the world" do
    assert FinancesBackend.hello() == :world
  end
end
