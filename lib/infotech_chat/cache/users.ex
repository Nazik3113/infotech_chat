defmodule InfotechChat.Cache.Users do
  @moduledoc """
    Модуль для роботи з кешем користувачів.
  """

  require Logger

  @cache_name :users

  @doc false
  @spec get_user_id! :: integer() | nil
  def get_user_id! do
    case Cachex.incr(@cache_name, "infotech") do
      {:ok, user_count} ->
        user_count

      error ->
        Logger.error(
          inspect("""
            Помилка в функції: #{__MODULE__}.get_user!
            Error: #{inspect(error)}
          """)
        )

        nil
    end
  end
end
