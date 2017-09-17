# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :rechan,
  ecto_repos: [Rechan.Repo]

# Configures the endpoint
config :rechan, RechanWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "mInP0HlM2ixQ/l17G/9/xCXvBbf/mc3jj4sKAe7dw3pZIDQnIKdm+uiWhebzqZHL",
  render_errors: [view: RechanWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Rechan.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
