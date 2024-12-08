defmodule InfotechChat.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  require Cachex.Spec

  require N2O

  use Application

  # роутер для головної сторінки, сторінки кімнат а такоє сокета

  def route(<<"/ws/", p::binary>>), do: route(p)
  def route(<<"index", _::binary>>), do: InfotechChatWeb.Controllers.Index
  def route(<<"room", _::binary>>), do: InfotechChatWeb.Controllers.Room

  # інтерфейс N2O роутера

  def finish(state, ctx), do: {:ok, state, ctx}

  def init(state, context) do
    %{path: path} = N2O.cx(context, :req)
    {:ok, state, N2O.cx(context, path: path, module: route(path))}
  end

  @impl true
  def start(_type, _args) do
    children = [
      # Distributed кеш для зберігання даних про користувачів.
      Supervisor.child_spec(
        {
          Cachex,
          [
            :users,
            [
              router:
                Cachex.Spec.router(
                  module: Cachex.Router.Ring,
                  options: [
                    monitor: true
                  ]
                ),
              expiration:
                Cachex.Spec.expiration(
                  default: :timer.seconds(60 * 5),
                  interval: :timer.seconds(10)
                )
            ]
          ]
        },
        id: {Cachex, :users}
      ),
      # Distributed кеш для зберігання даних про повідомлення.
      Supervisor.child_spec(
        {
          Cachex,
          [
            :chats,
            [
              router:
                Cachex.Spec.router(
                  module: Cachex.Router.Ring,
                  options: [
                    monitor: true
                  ]
                ),
              expiration:
                Cachex.Spec.expiration(
                  default: :timer.seconds(60 * 5),
                  interval: :timer.seconds(10)
                )
            ]
          ]
        },
        id: {Cachex, :chats}
      ),
      # WebSocket сервер
      {Bandit, scheme: :http, port: 8002, plug: InfotechChat.Ws},
      # Сервер, що віддає статику
      {Bandit, scheme: :http, port: 8004, plug: InfotechChat.Static}
      # Starts a worker by calling: InfotechChat.Worker.start_link(arg)
      # {InfotechChat.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: InfotechChat.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
