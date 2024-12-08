defmodule InfotechChat.Session.User do
  @moduledoc """
    Модуль для роботи з користувачами в сесії.
  """

  alias InfotechChat.Cache.Users, as: UsersCache

  @doc false
  @spec user!() :: String.t()
  def user!() do
    case :n2o.user() do
      user when is_bitstring(user) ->
        user

      _ ->
        :n2o.user("Користувач #{UsersCache.get_user_id!()}")
    end
  end
end
