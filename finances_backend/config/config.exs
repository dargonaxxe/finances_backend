import Config

config :finances_backend, :ecto_repos, [Finances.Repo]

import_config("#{config_env()}.exs")
