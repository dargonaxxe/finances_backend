import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :finances_web, FinancesWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "D3LxtvC0DKTazmgRDh/HvGLhkvSzF3TBnTu4aBqk7tH13uRj39i9j+4hQV16ln25",
  server: false,
  live_view: [signing_salt: "F56YSWzIjMZvAAIG"]

config :finances_backend, Finances.Repo,
  database: System.get_env("DATABASE_NAME"),
  username: System.get_env("DATABASE_USERNAME"),
  password: System.get_env("DATABASE_PASSWORD"),
  hostname: System.get_env("DATABASE_HOSTNAME"),
  pool: Ecto.Adapters.SQL.Sandbox,
  log: false

config :bcrypt_elixir, log_rounds: 4
