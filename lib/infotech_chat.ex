defmodule InfotechChat do
  @moduledoc """
    The entrypoint for defining your interfaces, such
    as controllers, views, channels and so on.

    This can be used in your application as:

        use InfotechChat, :controller

    The definitions below will be executed for every view,
    controller, etc, so keep them short and clean, focused
    on imports, uses and aliases.

    Do NOT define functions inside the quoted expressions
    below. Instead, define any helper function in modules
    and import those modules here.
  """

  def controller() do
    quote do
      require Logger
      require NITRO
      require N2O
    end
  end

  @doc """
    When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
