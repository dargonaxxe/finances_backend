ExUnit.start()

defmodule FinancesBackend.Session.Usecase.CreateSessionTest do
  alias FinancesBackend.Session.Usecase.CreateSession
  use FinancesBackend.RepoCase

  test "should insert without error" do
    {:ok, user} = FinancesBackend.sign_up("username", "passpasspass")
    {:ok, session} = CreateSession.execute(user.id)
    assert session.user_id == user.id
  end

  test "should return error because user does not exist" do
    {:error, reason} = CreateSession.execute(123)
    [user: {_, [constraint: :assoc, constraint_name: _]}] = reason.errors
  end
end
