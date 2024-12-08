defmodule InfotechChat.Session.Room do
  @moduledoc """
    Модуль для роботи з кімнатами в сесії.
  """

  @doc false
  @spec room_id!() :: String.t()
  def room_id!() do
    case :n2o.session(:room_id) do
      room_name when is_bitstring(room_name) ->
        room_name

      _ ->
        :n2o.session(:room_id, "1")
    end
  end
end
