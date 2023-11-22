# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :daveslist,
  ecto_repos: [Daveslist.Repo]

# Configures the endpoint
config :daveslist, DaveslistWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: DaveslistWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Daveslist.PubSub,
  live_view: [signing_salt: "+2V7Fcmb"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
#config :daveslist, Daveslist.Mailer, adapter: Swoosh.Adapters.Local

# Swoosh API client is needed for adapters other than SMTP.
#config :swoosh, :api_client, false

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.14.29",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :daveslist, :phoenix_swagger,
  swagger_files: %{
    "priv/static/swagger.json" => [
      router: DaveslistWeb.Router,
      endpoint: DaveslistWeb.Endpoint
    ]
  }

config :phoenix_swagger, json_library: Jason

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason


config :daveslist, Daveslist.UserManager.Guardian,
       issuer: "daveslist",
       secret_key: System.get_env["GUARDIAN_SECRET_KEY"]

config :daveslist, Daveslist.Mailer,
       adapter: Bamboo.SMTPAdapter,
       server: System.get_env["MAIL_SERVER"],
       port: System.get_env["PORT"],
       username: System.get_env["USERNAME"],
       password: System.get_env["PASSWORD"],
       tls: :always,
       retries: 1

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
