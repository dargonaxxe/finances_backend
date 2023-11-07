ExUnit.start()

defmodule FinancesBackend.SessionRepoTest do
  use FinancesBackend.RepoCase

  alias FinancesBackend.Session

  test "should check user existence" do
    session = %Session{}

    params = %{
      user_id: 123,
      token: "123123123",
      valid_until: DateTime.utc_now()
    }

    {:error, reason} =
      Session.changeset(session, params)
      |> Repo.insert()

    [user: {_, [constraint: :assoc, constraint_name: _]}] = reason.errors
  end
end
