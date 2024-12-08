import Config

config :elixir, :time_zone_database, Tzdata.TimeZoneDatabase

config :n2o,
  app: :infotech_chat,
  pickler: :n2o_secret,
  mq: :n2o_syn,
  upload: "./priv/static",
  nitro_prolongate: true,
  ttl: 60,
  protocols: [:nitro_n2o],
  routes: InfotechChat.Application
