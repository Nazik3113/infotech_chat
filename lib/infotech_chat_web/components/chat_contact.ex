defmodule InfotechChat.Components.ChatContact do
  @moduledoc """
    Модуль для компонентів контактів.
  """

  require NITRO

  alias InfotechChat.Helpers.Nitro

  @doc false
  @spec generate!(String.t(), String.t(), String.t(), Date.t()) :: tuple()
  def generate!(room_name, name, message, %Date{} = message_date) do
    NITRO.li(
      body: [
        NITRO.link(
          id: room_name,
          href: "#",
          postback: :room,
          source: [:room_name],
          onclick:
            :nitro.jse("document.getElementById('room_name').value = '#{room_name}';")
            |> :nitro.hte(),
          body: [
            Nitro.i(
              class: "direct-chat-img bg-gray d-flex justify-content-center align-items-center",
              body: String.first(name)
            ),
            NITRO.div(
              class: "contacts-list-info",
              body: [
                NITRO.span(
                  class: "contacts-list-name",
                  body: [
                    name,
                    Nitro.small(
                      class: "contacts-list-date float-right",
                      body: Date.to_string(message_date)
                    )
                  ]
                ),
                NITRO.span(class: "contacts-list-msg", body: message)
              ]
            )
          ]
        )
      ]
    )
  end
end
