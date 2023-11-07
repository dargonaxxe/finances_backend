ExUnit.start()

defmodule FinancesBackend.SignInTest do
  use FinancesBackend.RepoCase

  test "should return :invalid_credentials when no user found" do
    {:error, :invalid_credentials} = FinancesBackend.sign_in("username", "passpasspass")
  end

  test "should return :invalid_credentials when password is wrong" do
    {:ok, _} = FinancesBackend.sign_up("username", "passpasspass")
    {:error, :invalid_credentials} = FinancesBackend.sign_in("username", "password")
  end

  test "should return session when everything is fine" do
    {:ok, user} = FinancesBackend.sign_up("username", "passpasspass")
    {:ok, session} = FinancesBackend.sign_in("username", "passpasspass")
    assert session.user_id == user.id
  end
end
