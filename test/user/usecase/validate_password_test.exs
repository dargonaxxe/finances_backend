ExUnit.start()

defmodule FinancesBackend.User.Usecase.ValidatePasswordTest do
  alias FinancesBackend.User.Usecase.ValidatePassword
  use FinancesBackend.RepoCase

  test "should return :invalid_credentials when no user found" do
    {:error, :invalid_credentials} = ValidatePassword.execute("username", "password")
  end

  test "should return :invalid_credentials when invalid password is used" do
    FinancesBackend.sign_up("username", "passpasspass")
    {:error, :invalid_credentials} = ValidatePassword.execute("username", "password")
  end

  test "should return :ok when password is valid" do
    FinancesBackend.sign_up("username", "passpasspass")
    :ok = ValidatePassword.execute("username", "passpasspass")
  end
end
