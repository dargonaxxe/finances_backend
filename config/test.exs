import Config

config :finances_backend, Finances.Repo,
  database: System.get_env("DATABASE_NAME"),
  username: System.get_env("DATABASE_USERNAME"),
  password: System.get_env("DATABASE_PASSWORD"),
  hostname: System.get_env("DATABASE_HOSTNAME"),
  pool: Ecto.Adapters.SQL.Sandbox,
  log: false
