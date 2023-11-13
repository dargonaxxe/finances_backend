defmodule FinancesBackend.Account.Usecase.GetAccount do
  @moduledoc """
  Get account by its id 
  """
  alias FinancesBackend.Account
  alias Finances.Repo

  @type id() :: integer()
  @spec execute(id()) :: Account | nil
  def execute(id) do
    Repo.get_by(Account, id: id)
  end
end
