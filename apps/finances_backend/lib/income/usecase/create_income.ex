defmodule FinancesBackend.Income.Usecase.CreateIncome do
  @moduledoc """
  Usecase to create an income. Launches a transaction that 
  1. Increases the account balance 
  2. Inserts a row into a "incomes" table 
  """
  alias Finances.Repo
  alias FinancesBackend.Account.Usecase.WithAccount
  alias FinancesBackend.Income

  import Ecto.Changeset, only: [change: 2]

  def execute(account_id, amount, comment, date) do
    WithAccount.execute(account_id, fn account ->
      params = %{
        account_id: account_id,
        amount: amount,
        comment: comment,
        date: date
      }

      changeset =
        %Income{}
        |> Income.changeset(params)

      try do
        Repo.transaction(fn repo ->
          change(account, balance: account.balance + amount)
          |> repo.update!()

          repo.insert!(changeset)
        end)
      rescue
        e in Ecto.InvalidChangesetError ->
          {:error, e}
      end
    end)
  end
end
