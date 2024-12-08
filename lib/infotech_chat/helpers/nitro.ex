defmodule InfotechChat.Helpers.Nitro do
  @moduledoc """
    Модуль з допоміжними функціями у роботі з NITRO.
  """

  @doc """
    Генеруємо HTML елемент <i></i>, оскільки не знайшов як це зробити через NITRO.
  """
  @spec i(list()) :: tuple()
  def i(args) do
    {:i, :element, [], [], [], [], [], [], Keyword.get(args, :class, []), [], [], [], [], [], [],
     [], [], [], [], [], [], Keyword.get(args, :body, []), [], [], true, false, "i", [], [], [],
     [], [], [], [], [], [], [], [], [], [], [], [], [], [], []}
  end

  @doc """
    Генеруємо HTML елемент <small></small>, оскільки не знайшов як це зробити через NITRO.
  """
  @spec small(list()) :: tuple()
  def small(args) do
    {:small, :element, [], [], [], [], [], [], Keyword.get(args, :class, []), [], [], [], [], [],
     [], [], [], [], [], [], [], Keyword.get(args, :body, []), [], [], true, false, "small", [],
     [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], []}
  end
end
