defmodule InfotechChat.Ws do
  require N2O

  use Plug.Router

  @router Application.compile_env(:n2o, :router, InfotechChat.Application)

  plug(:match)
  plug(:dispatch)

  get("/ws/:module",
    do:
      conn
      |> Plug.Conn.upgrade_adapter(
        :websocket,
        {
          __MODULE__,
          [
            module: extract(module),
            state: URI.decode_query(Map.get(conn, :query_string, ""))
          ],
          timeout: 60_000
        }
      )
      |> halt()
  )

  def extract(route) do
    @router.route(route)
  end

  def init(args) do
    {
      :ok,
      N2O.cx(
        module: Keyword.get(args, :module),
        state: Keyword.get(args, :state, %{})
      )
    }
  end

  def handle_in({"N2O," <> _ = message, _}, state) do
    response(:n2o_proto.stream({:text, message}, [], state))
  end

  def handle_in({"PING", _}, state) do
    {:reply, :ok, {:text, "PONG"}, state}
  end

  def handle_in({message, _}, state) when is_binary(message) do
    response(:n2o_proto.stream({:binary, message}, [], state))
  end

  def handle_info(message, state) do
    response(:n2o_proto.info(message, [], state))
  end

  def response({:reply, {:binary, rep}, _, s}), do: {:reply, :ok, {:binary, rep}, s}
  def response({:reply, {:text, rep}, _, s}), do: {:reply, :ok, {:text, rep}, s}

  def response({:reply, {:bert, rep}, _, s}),
    do: {:reply, :ok, {:binary, :n2o_bert.encode(rep)}, s}

  def response({:reply, {:json, rep}, _, s}),
    do: {:reply, :ok, {:binary, :n2o_json.encode(rep)}, s}

  match _ do
    send_resp(conn, 404, "Please refer to nazarii.spikhalskyi@gmail.com for more information.")
  end
end
