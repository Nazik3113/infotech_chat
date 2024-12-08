defmodule InfotechChatWeb.Controllers.Room do
  use InfotechChat, :controller

  alias InfotechChat.Helpers.Date, as: DateHelpers
  alias InfotechChat.Session.User, as: UserSession
  alias InfotechChat.Session.Room, as: RoomSession
  alias InfotechChat.Cache.Chats, as: ChatsCache
  alias InfotechChat.Components.ChatMessage

  @doc false
  @spec event(any()) :: any()
  def event(:init) do
    user = UserSession.user!()
    room_id = RoomSession.room_id!()
    chat_messages = ChatsCache.get_messages!(room_id)
    messages_count = ChatsCache.get_messages_count!(room_id)

    :n2o.reg({:topic, room_id})

    :nitro.update(
      :chat_title,
      NITRO.h3(
        class: "card-title",
        id: "chat_title",
        body: "Infotech Chat | Кімната #{room_id}"
      )
    )

    :nitro.clear(:direct_chat_messages)

    if is_list(chat_messages) do
      Enum.each(chat_messages, fn {m_user, message, date} ->
        :nitro.insert_bottom(
          :direct_chat_messages,
          ChatMessage.generate!(m_user, message, date, String.equivalent?(user, m_user))
        )
      end)
    else
      :nitro.insert_bottom(
        :direct_chat_messages,
        NITRO.h2(body: "На даний момент повідомлень немає...")
      )
    end

    :nitro.update(
      :messages_count,
      NITRO.span(
        class: "badge badge-light",
        id: "messages_count",
        data_fields: [{"data-toggle", "tooltip"}],
        title: "#{messages_count} Rooms",
        body: "#{messages_count}"
      )
    )

    :nitro.update(
      :send,
      NITRO.button(
        class: "btn btn-primary",
        type: "button",
        id: "send",
        postback: :message,
        body: "Надіслати",
        source: [:message]
      )
    )
  end

  def event(:message) do
    message = :nitro.q(:message)

    if is_bitstring(message) and byte_size(message) > 1 do
      room_id = RoomSession.room_id!()
      user = UserSession.user!()

      message_tuple = {user, message, DateHelpers.now_naive_datetime!()}

      ChatsCache.add_message!(room_id, message_tuple)

      :n2o.send({:topic, room_id}, N2O.client(data: message_tuple))
    end
  end

  def event({:client, {user, message, date}}) do
    room_id = RoomSession.room_id!()

    messages_count = ChatsCache.get_messages_count!(room_id)

    if messages_count == 1 do
      :nitro.clear(:direct_chat_messages)
    end

    :nitro.update(
      :messages_count,
      NITRO.span(
        class: "badge badge-light",
        id: "messages_count",
        data_fields: [{"data-toggle", "tooltip"}],
        title: "#{messages_count} Rooms",
        body: "#{messages_count}"
      )
    )

    :nitro.update(
      :message,
      NITRO.input(
        type: "text",
        id: "message",
        name: "message",
        placeholder: "Напишіть повідомлення...",
        class: "form-control",
        value: ""
      )
    )

    :nitro.insert_bottom(
      :direct_chat_messages,
      ChatMessage.generate!(user, message, date, String.equivalent?(user, UserSession.user!()))
    )
  end

  def event(unexpected), do: unexpected |> inspect() |> Logger.warning()
end
