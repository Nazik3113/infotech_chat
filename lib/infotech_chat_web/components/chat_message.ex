defmodule InfotechChat.Components.ChatMessage do
  @moduledoc """
    Модуль для компонентів повідомлень.
  """

  require NITRO

  alias InfotechChat.Helpers.Nitro

  @doc false
  @spec generate!(String.t(), String.t(), NaiveDateTime.t(), boolean()) :: tuple()
  def generate!(author, message, %NaiveDateTime{} = message_date, is_author) do
    NITRO.div(
      class: if(is_author == true, do: "direct-chat-msg right", else: "direct-chat-msg"),
      body: [
        NITRO.div(
          class: "direct-chat-infos clearfix",
          body: [
            NITRO.span(
              class:
                if(is_author == true,
                  do: "direct-chat-name float-right",
                  else: "direct-chat-name float-left"
                ),
              body: author
            ),
            NITRO.span(
              class:
                if(is_author == true,
                  do: "direct-chat-timestamp float-left",
                  else: "direct-chat-timestamp float-right"
                ),
              body: NaiveDateTime.truncate(message_date, :second) |> NaiveDateTime.to_string()
            )
          ]
        ),
        Nitro.i(
          class: "direct-chat-img bg-gray d-flex justify-content-center align-items-center",
          body: String.first(author)
        ),
        NITRO.div(
          class: "direct-chat-text",
          body: message
        )
      ]
    )
  end
end
