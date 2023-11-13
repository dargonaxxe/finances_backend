defmodule FinancesBackend.Account.Usecase.GetAccounts do
  @moduledoc """
  A usecase that returns a list of all accounts user has 
  """
  alias FinancesBackend.Account
  alias Finances.Repo

  import Ecto.Query

  def execute(user_id) do
    query = from a in Account, where: a.user_id == ^user_id
    Repo.all(query)
  end
end
