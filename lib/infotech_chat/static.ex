defmodule InfotechChat.Static do
  use Plug.Router

  @app Application.compile_env(:n2o, :app, :infotech_chat)
  @dir Application.compile_env(:n2o, :upload, "./priv/static")

  plug(Plug.Static, at: "/", from: {@app, @dir})

  plug(:match)
  plug(:dispatch)

  match _ do
    send_resp(conn, 404, "Please refer to nazarii.spikhalskyi@gmail.com for more information.")
  end
end
