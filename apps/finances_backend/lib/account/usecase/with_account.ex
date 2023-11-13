defmodule FinancesBackend.Account.Usecase.WithAccount do
  @moduledoc """
  Usecase that retrieves an account with given id and launches given lambda function 
  if account with provided id is found. Otherwise, returns {:error, {:invalid_account_id, account_id}}
  """
  alias FinancesBackend.Account
  alias FinancesBackend.Account.Usecase.GetAccount

  def execute(account_id, lambda) do
    case GetAccount.execute(account_id) do
      nil ->
        {:error, {:invalid_account_id, account_id}}

      %Account{} = account ->
        lambda.(account)
    end
  end
end
