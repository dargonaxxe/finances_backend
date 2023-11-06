defmodule FinancesBackend.Application do
  @moduledoc """
  Root supervisor. Contains all the necessary dependencies for the application. 
  """
  use Application

  @impl Application
  def start(_, _) do
    children = [
      Finances.Repo
    ]

    opts = [strategy: :one_for_one, name: FinancesBackend.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
