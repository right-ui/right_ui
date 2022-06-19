import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :lab_web, LabWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "L1AR6Jfc9MQlvibpA9ANUpq1jcYlZ/1UHW0nmqk5mNgiyh+pQj+sm2xixoGDCJSr",
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# In test we don't send emails.
config :lab, Lab.Mailer, adapter: Swoosh.Adapters.Test

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
