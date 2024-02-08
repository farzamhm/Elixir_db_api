import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :elixir_api_db, ElixirApiDb.Repo,
  adapter: Ecto.Adapters.MyXQL,
  username: "superuser",
  password: "#Yd5vp0iquSOJZ7kB#N93ipr3w3gh(7)r",
  hostname: "db.sandbox.brainboxai.net",
  database: "architecture_devs",
  stacktrace: true,
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :elixir_api_db, ElixirApiDbWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "FV/GzsaG1rTNvNgyQhrZB4Khmangjx0/EkAxxooY1w65DRfrPfiVmBx4eUTGF5Te",
  server: false

# In test we don't send emails.
config :elixir_api_db, ElixirApiDb.Mailer, adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
