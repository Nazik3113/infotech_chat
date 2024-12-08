defmodule InfotechChatWeb.Controllers.Index do
  use InfotechChat, :controller

  alias InfotechChat.Helpers.Date, as: DateHelpers
  alias InfotechChat.Components.ChatContact

  def event(:init) do
    now_date = DateHelpers.now_date!()

    :nitro.update(
      :rooms_count,
      NITRO.span(
        class: "badge badge-light",
        id: "rooms_count",
        data_fields: [{"data-toggle", "tooltip"}],
        title: "3 Rooms",
        body: "3"
      )
    )

    :nitro.clear(:contacts_list)

    :nitro.insert_bottom(
      :contacts_list,
      ChatContact.generate!(
        "room1",
        "Кімната 1",
        "Перейдіть, щоб побачити повідомлення...",
        now_date
      )
    )

    :nitro.insert_bottom(
      :contacts_list,
      ChatContact.generate!(
        "room2",
        "Кімната 2",
        "Перейдіть, щоб побачити повідомлення...",
        now_date
      )
    )

    :nitro.insert_bottom(
      :contacts_list,
      ChatContact.generate!(
        "room3",
        "Кімната 3",
        "Перейдіть, щоб побачити повідомлення...",
        now_date
      )
    )
  end

  def event(:room) do
    "room" <> room_id = :nitro.q(:room_name)

    :n2o.session(:room_id, :nitro.to_binary(room_id))

    :nitro.redirect(["/room.html"])
  end

  def event(unexpected), do: unexpected |> inspect() |> Logger.warning()
end
