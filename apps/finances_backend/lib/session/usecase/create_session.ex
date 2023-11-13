defmodule FinancesBackend.Session.Usecase.CreateSession do
  @moduledoc """
  Usecase that creates session. Used in sign-in scenario
  """
  alias Finances.Repo
  alias FinancesBackend.Session

  @type id :: integer()
  @spec execute(id()) :: {:ok, Session} | {:error, any()}
  def execute(user_id) do
    params = %{
      token: UUID.uuid1(),
      user_id: user_id,
      valid_until: valid_until()
    }

    %Session{}
    |> Session.changeset(params)
    |> Repo.insert()
  end

  @session_valid_days 1
  defp valid_until() do
    DateTime.utc_now()
    |> DateTime.add(@session_valid_days, :day)
  end
end
