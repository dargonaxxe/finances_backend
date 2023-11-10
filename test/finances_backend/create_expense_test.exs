ExUnit.start()

defmodule FinancesBackend.CreateExpenseTest do
  alias FinancesBackend.Expense
  alias FinancesBackend.Account.Usecase.GetAccount
  use FinancesBackend.RepoCase

  @money_expense Money.new(122, "USD")
  @money_account Money.new(123, "USD")
  @money_budget Money.new(124, "USD")
  @date_budget_start Date.from_iso8601!("2023-01-01")
  @date_budget_end Date.from_iso8601!("2024-01-01")
  test "should return no error and change account balance value" do
    {:ok, user} = FinancesBackend.sign_up("username", "passpasspass")
    {:ok, account} = FinancesBackend.create_account(@money_account, user.id, "account-name")

    {:ok, budget} =
      FinancesBackend.create_budget(
        @money_budget,
        user.id,
        "budget-name",
        @date_budget_start,
        @date_budget_end
      )

    {:ok, expense} =
      FinancesBackend.create_expense(
        budget.id,
        account.id,
        @date_budget_start,
        @money_expense.amount,
        "comment"
      )

    assert expense.budget_id == budget.id
    assert expense.account_id == account.id
    assert expense.date == @date_budget_start
    assert expense.amount == @money_expense.amount
    assert expense.comment == "comment"

    account_updated = GetAccount.execute(account.id)
    assert account_updated.balance == account.balance - expense.amount
  end

  test "should check account existence" do
    {:ok, user} = FinancesBackend.sign_up("username", "passpasspass")

    {:ok, budget} =
      FinancesBackend.create_budget(
        @money_budget,
        user.id,
        "budget-name",
        @date_budget_start,
        @date_budget_end
      )

    {:error, {:invalid_account_id, 1}} =
      FinancesBackend.create_expense(
        budget.id,
        1,
        @date_budget_start,
        @money_expense.amount,
        ""
      )
  end

  test "should check budget existence" do
    {:ok, user} = FinancesBackend.sign_up("username", "passpasspass")
    {:ok, account} = FinancesBackend.create_account(@money_account, user.id, "account-name")

    {:error, {:invalid_budget_id, 1}} =
      FinancesBackend.create_expense(1, account.id, @date_budget_start, @money_expense.amount, "")
  end

  test "should check budget and account belong to the same person" do
    {:ok, user_1} = FinancesBackend.sign_up("username", "passpasspass")
    {:ok, user_2} = FinancesBackend.sign_up("username_2", "passpasspass")
    {:ok, account} = FinancesBackend.create_account(@money_account, user_1.id, "account-name")

    {:ok, budget} =
      FinancesBackend.create_budget(
        @money_budget,
        user_2.id,
        "budget-name",
        @date_budget_start,
        @date_budget_end
      )

    {:error, :budget_and_account_belong_to_different_users} =
      FinancesBackend.create_expense(
        budget.id,
        account.id,
        @date_budget_start,
        @money_expense.amount,
        ""
      )
  end

  test "should check date is before budget end" do
    {:ok, user} = FinancesBackend.sign_up("username", "passpasspass")
    {:ok, account} = FinancesBackend.create_account(@money_account, user.id, "account-name")

    {:ok, budget} =
      FinancesBackend.create_budget(
        @money_budget,
        user.id,
        "budget-name",
        @date_budget_start,
        @date_budget_end
      )

    date = Date.add(@date_budget_end, 1)

    {:error,
     {:date_is_out_of_budget, [date: ^date, start: @date_budget_start, end: @date_budget_end]}} =
      FinancesBackend.create_expense(budget.id, account.id, date, @money_expense.amount, "")
  end

  test "should check date is after budget start" do
    {:ok, user} = FinancesBackend.sign_up("username", "passpasspass")
    {:ok, account} = FinancesBackend.create_account(@money_account, user.id, "account-name")

    {:ok, budget} =
      FinancesBackend.create_budget(
        @money_budget,
        user.id,
        "budget-name",
        @date_budget_start,
        @date_budget_end
      )

    date = Date.add(@date_budget_start, -1)

    {:error,
     {:date_is_out_of_budget, [date: ^date, start: @date_budget_start, end: @date_budget_end]}} =
      FinancesBackend.create_expense(budget.id, account.id, date, @money_expense.amount, "")
  end

  test "should check that amount is positive" do
    {:ok, user} = FinancesBackend.sign_up("username", "passpasspass")
    {:ok, account} = FinancesBackend.create_account(@money_account, user.id, "account-name")

    {:ok, budget} =
      FinancesBackend.create_budget(
        @money_budget,
        user.id,
        "budget-name",
        @date_budget_start,
        @date_budget_end
      )

    {:error, reason} =
      FinancesBackend.create_expense(budget.id, account.id, @date_budget_start, 0, "")

    [amount: {_, [constraint: :check, constraint_name: "amount_should_be_positive"]}] =
      reason.changeset.errors
  end

  test "should check that account balance is more that expense" do
    {:ok, user} = FinancesBackend.sign_up("username", "passpasspass")
    {:ok, account} = FinancesBackend.create_account(@money_account, user.id, "account-name")

    {:ok, budget} =
      FinancesBackend.create_budget(
        @money_budget,
        user.id,
        "budget-name",
        @date_budget_start,
        @date_budget_end
      )

    {:error, {:insufficient_balance, [balance: 123, amount: 124]}} =
      FinancesBackend.create_expense(
        budget.id,
        account.id,
        @date_budget_start,
        @money_account.amount + 1,
        ""
      )
  end

  test "should check that account and budget currencies are the same" do
    {:ok, user} = FinancesBackend.sign_up("username", "passpasspass")
    {:ok, account} = FinancesBackend.create_account(@money_account, user.id, "account-name")

    {:ok, budget} =
      FinancesBackend.create_budget(
        Money.new(@money_budget.amount, "EUR"),
        user.id,
        "budget-name",
        @date_budget_start,
        @date_budget_end
      )

    {:error,
     {:account_currency_differs_from_budget, [account_currency: 840, budget_currency: 978]}} =
      FinancesBackend.create_expense(
        budget.id,
        account.id,
        @date_budget_start,
        @money_expense.amount,
        ""
      )
  end

  test "when transaction fails, account balance should not change" do
    {:ok, user} = FinancesBackend.sign_up("username", "passpasspass")
    {:ok, account} = FinancesBackend.create_account(@money_account, user.id, "account-name")

    {:ok, budget} =
      FinancesBackend.create_budget(
        @money_budget,
        user.id,
        "budget-name",
        @date_budget_start,
        @date_budget_end
      )

    {:error, _} = FinancesBackend.create_expense(budget.id, account.id, @date_budget_start, 0, "")
    ^account = GetAccount.execute(account.id)
    [] = Repo.all(Expense)
  end
end
