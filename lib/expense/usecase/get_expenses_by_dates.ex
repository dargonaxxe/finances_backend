defmodule FinancesBackend.Expense.Usecase.GetExpensesByDates do
  @moduledoc """
  Usecase that returns a Date -> ExpensesByDate map for a given budget.
  """
  alias FinancesBackend.Budget.Usecase.WithBudget
  alias FinancesBackend.Expense.Usecase.GetExpenses
  alias FinancesBackend.Expense.Model.ExpensesByDate

  def execute(budget_id) do
    WithBudget.execute(budget_id, fn budget ->
      expenses = GetExpenses.execute(budget_id)

      get_expenses_by_dates(
        budget.start_date,
        budget.end_date,
        expenses,
        budget.daily_prognosis
      )
    end)
  end

  defp get_expenses_by_dates(
         %Date{} = current_date,
         %Date{} = end_date,
         expenses,
         daily_prognosis,
         result \\ %{},
         cumulative_expenses \\ 0,
         budget_proficit \\ 0
       ) do
    if Date.after?(current_date, end_date) do
      result
    else
      {expenses_by_date, other_expenses} =
        get_expenses_by_date(
          current_date,
          expenses,
          cumulative_expenses,
          budget_proficit,
          daily_prognosis
        )

      get_expenses_by_dates(
        Date.add(current_date, 1),
        end_date,
        other_expenses,
        daily_prognosis,
        Map.put(result, current_date, expenses_by_date),
        expenses_by_date.cumulative_expenses,
        expenses_by_date.budget_proficit
      )
    end
  end

  defp get_expenses_by_date(
         %Date{} = current_date,
         expenses,
         cumulative_expenses,
         budget_proficit,
         daily_prognosis
       ) do
    {this_date, remaining} = split_by_date(current_date, expenses)

    local_expenses =
      Enum.map(this_date, fn x -> x.amount end)
      |> Enum.sum()

    {%ExpensesByDate{
       cumulative_expenses: cumulative_expenses + local_expenses,
       local_expenses: local_expenses,
       budget_proficit: budget_proficit + daily_prognosis - local_expenses,
       expenses: Enum.reverse(this_date)
     }, remaining}
  end

  defp split_by_date(date, expenses, result \\ [])

  defp split_by_date(%Date{} = date, [expense | tail] = expenses, result) do
    if expense.date == date do
      split_by_date(date, tail, [expense | result])
    else
      {result, expenses}
    end
  end

  defp split_by_date(_, [], result), do: {result, []}
end
