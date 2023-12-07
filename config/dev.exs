import Config

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we can use it
# to bundle .js and .css sources.
config :finances_web, FinancesWeb.Endpoint,
  # Binding to loopback ipv4 address prevents access from other machines.
  # Change to `ip: {0, 0, 0, 0}` to allow access from other machines.
  http: [ip: {127, 0, 0, 1}, port: 4000],
  check_origin: false,
  code_reloader: true,
  debug_errors: true,
  secret_key_base: "1f85767FJarBb9EenjrdUaPXbA+t5AflB7ht+9j5K5Vh66S0COjsVKWeAIwWVfOx",
  watchers: [
    esbuild: {Esbuild, :install_and_run, [:default, ~w(--sourcemap=inline --watch)]},
    tailwind: {Tailwind, :install_and_run, [:default, ~w(--watch)]}
  ]

# ## SSL Support
#
# In order to use HTTPS in development, a self-signed
# certificate can be generated by running the following
# Mix task:
#
#     mix phx.gen.cert
#
# Run `mix help phx.gen.cert` for more information.
#
# The `http:` config above can be replaced with:
#
#     https: [
#       port: 4001,
#       cipher_suite: :strong,
#       keyfile: "priv/cert/selfsigned_key.pem",
#       certfile: "priv/cert/selfsigned.pem"
#     ],
#
# If desired, both `http:` and `https:` keys can be
# configured to run both http and https servers on
# different ports.

# Watch static and templates for browser reloading.
config :finances_web, FinancesWeb.Endpoint,
  live_reload: [
    patterns: [
      ~r"priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$",
      ~r"priv/gettext/.*(po)$",
      ~r"lib/finances_web/(controllers|live|components)/.*(ex|heex)$"
    ]
  ],
  pubsub_server: FinancesWeb.PubSub

# Enable dev routes for dashboard and mailbox
config :finances_web, dev_routes: true

config :finances_backend, Finances.Repo,
  database: System.get_env("DATABASE_NAME"),
  username: System.get_env("DATABASE_USERNAME"),
  password: System.get_env("DATABASE_PASSWORD"),
  hostname: System.get_env("DATABASE_HOSTNAME")

path_assets = Path.expand("../apps/finances_web/assets/", __DIR__)

config :tailwind,
  version: "3.3.6",
  default: [
    args: ~w(
  --config=tailwind.config.js
  --input=css/app.css
  --output=../priv/static/assets/app.css),
    cd: path_assets
  ]

config :esbuild,
  version: "0.18.6",
  default: [
    args: ~w(
    js/app.js 
    --bundle 
    --target=es2016 
    --outdir=../priv/static/assets
  ),
    cd: path_assets,
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]
