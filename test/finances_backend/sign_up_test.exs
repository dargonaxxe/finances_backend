defmodule FinancesBackend.SignUpTest do
  use ExUnit.Case
  doctest FinancesBackend

  use FinancesBackend.RepoCase

  test "should create user" do
    {:ok, result} = FinancesBackend.sign_up("username", "passpasspass")
    assert result.username == "username"
  end

  test "should fail to create user due to unique constraint" do
    {:ok, _} = FinancesBackend.sign_up("username", "passpasspass")
    {:error, reason} = FinancesBackend.sign_up("username", "passpasspass")
    [username: {_, [constraint: :unique, constraint_name: _]}] = reason.errors
  end

  test "should fail to create user due to password length restriction" do
    {:error, reason} = FinancesBackend.sign_up("username", "pass")
    [pwd_string: {_, [count: 12, validation: :length, kind: :min, type: :string]}] = reason.errors
  end

  test "should fail to create user due to username length restriction" do
    {:error, reason} = FinancesBackend.sign_up("usr", "passpasspass")
    [username: {_, [count: 6, validation: :length, kind: :min, type: :string]}] = reason.errors
  end
end
