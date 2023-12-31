ExUnit.start()

defmodule FinancesBackend.UserRepoTest do
  alias FinancesBackend.User
  use ExUnit.Case
  use FinancesBackend.RepoCase

  test "unique constaint should prevent duplicating usernames" do
    user = %User{}

    attrs = %{
      username: "username",
      password: "passpasspass"
    }

    {:ok, result} = User.changeset(user, attrs)

    {:ok, _} = Repo.insert(result)
    {:error, details} = Repo.insert(result)
    [username: {_, [constraint: :unique, constraint_name: _]}] = details.errors
  end
end
