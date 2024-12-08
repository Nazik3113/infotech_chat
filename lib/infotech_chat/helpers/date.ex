defmodule InfotechChat.Helpers.Date do
  @moduledoc """
    Допоміжні функції для роботи з часом.
  """

  @doc """
    Теперішній час по киву у форматі sql date.

    iex> Regex.match?(~r/\\d{4}\\-\\d{2}\\-\\d{2}/, #{__MODULE__}.now_date!() |> Date.to_string())
    true
  """
  @spec now_date! :: Date.t()
  def now_date!() do
    {:ok, now_datetime} =
      DateTime.utc_now()
      |> DateTime.shift_zone("Europe/Kiev")

    now_datetime |> DateTime.to_date()
  end

  @doc """
    Теперішній час по києву у форматі NaiveDateTime.
    iex> Regex.match?(~r/\\d{4}\\-\\d{2}\\-\\d{2}\\s\\d{2}\\:\\d{2}\\:\\d{2}\\.\\d{6}/, #{__MODULE__}.now_naive_datetime! |> NaiveDateTime.to_string)
    true
  """
  @spec now_naive_datetime! :: NaiveDateTime.t()
  def now_naive_datetime!() do
    {:ok, now_datetime} =
      DateTime.utc_now()
      |> DateTime.shift_zone("Europe/Kiev")

    {:ok, now_naive_datetime} =
      DateTime.to_iso8601(now_datetime)
      |> NaiveDateTime.from_iso8601()

    now_naive_datetime
  end
end
