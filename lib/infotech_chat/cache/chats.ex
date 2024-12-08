defmodule InfotechChat.Cache.Chats do
  @moduledoc """
    Модуль для роботи з кешем повідомлень.
  """

  require Logger

  @cache_name :chats

  @doc false
  @spec get_messages!(String.t()) :: list() | nil
  def get_messages!(room) do
    case Cachex.get(@cache_name, room) do
      {:ok, chats} ->
        chats

      error ->
        Logger.error(
          inspect("""
            Помилка в функції: #{__MODULE__}.get_messages!
            Error: #{inspect(error)}
          """)
        )

        nil
    end
  end

  @doc false
  @spec get_messages_count!(String.t()) :: integer()
  def get_messages_count!(room) do
    case Cachex.get(@cache_name, room <> "_mc") do
      {:ok, messages_count} when is_integer(messages_count) ->
        messages_count

      {:ok, nil} ->
        0

      error ->
        Logger.error(
          inspect("""
            Помилка в функції: #{__MODULE__}.get_messages_count!(room)
            Room: #{inspect(room)}
            Error: #{inspect(error)}
          """)
        )

        nil
    end
  end

  @doc false
  @spec add_message!(String.t(), map()) :: list() | nil
  def add_message!(room, message) do
    case get_messages!(room) do
      messages when is_list(messages) ->
        Cachex.put(@cache_name, room, messages ++ [message])

      nil ->
        Cachex.put(@cache_name, room, [message])
    end
    |> case do
      {:ok, true} ->
        Cachex.incr(@cache_name, room <> "_mc")

        true

      error ->
        Logger.error(
          inspect("""
            Помилка в функції: #{__MODULE__}.get_messages!
            Error: #{inspect(error)}
          """)
        )

        false
    end
  end
end
