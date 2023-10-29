defmodule Finances.Repo do
  use Ecto.Repo,
    otp_app: :finances_backend,
    adapter: Ecto.Adapters.Postgres
end
