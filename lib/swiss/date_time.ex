defmodule Swiss.DateTime do
  @moduledoc """
  Some extra functions for working with DateTimes that aren't in the native lib
  or on Timex.
  """

  @doc """
  Helper method for getting "now" with second precision.
  """
  @spec second_utc_now() :: DateTime.t
  def second_utc_now(),
    do: DateTime.utc_now() |> DateTime.truncate(:second)

  @doc """
  Returns the biggest (latest) of two dates.

  ## Examples
      iex> Swiss.DateTime.max(DateTime.from_unix!(1_577_664_000), DateTime.from_unix!(1_464_096_368))
      ~U[2019-12-30 00:00:00Z]
  """
  @spec max(DateTime.t(), DateTime.t()) :: DateTime.t()
  def max(date_1, date_2),
    do: max([date_1, date_2])

  @doc """
  Returns the biggest (latest) of the given list of dates.

  ## Examples
      iex> Swiss.DateTime.max([DateTime.from_unix!(1_577_664_000), DateTime.from_unix!(2_464_096_360), DateTime.from_unix!(1_464_096_368)])
      ~U[2048-01-31 15:12:40Z]

      iex> Swiss.DateTime.max([DateTime.from_unix!(2_464_096_360), nil])
      ~U[2048-01-31 15:12:40Z]
  """
  @spec max([DateTime.t()]) :: DateTime.t()
  def max(dates) when is_list(dates) do
    dates
    |> Enum.sort(fn date_1, date_2 ->
      is_nil(date_1) || is_nil(date_2) || DateTime.compare(date_1, date_2) != :lt
    end)
    |> List.first()
  end

  @doc """
  Returns the smallest (earliest) of two dates.

  ## Examples
      iex> Swiss.DateTime.min(DateTime.from_unix!(1_577_664_000), DateTime.from_unix!(1_464_096_368))
      ~U[2016-05-24 13:26:08Z]
  """
  @spec min(DateTime.t(), DateTime.t()) :: DateTime.t()
  def min(date_1, date_2),
    do: min([date_1, date_2])

  @doc """
  Returns the smallest (earliest) of the given list of dates.

  ## Examples
      iex> Swiss.DateTime.min([DateTime.from_unix!(1_577_664_000), DateTime.from_unix!(2_464_096_360), DateTime.from_unix!(1_464_096_368)])
      ~U[2016-05-24 13:26:08Z]

      iex> Swiss.DateTime.min([DateTime.from_unix!(2_464_096_360), nil])
      ~U[2048-01-31 15:12:40Z]
  """
  @spec min([DateTime.t()]) :: DateTime.t()
  def min(dates) when is_list(dates) do
    dates
    |> Enum.sort(fn date_1, date_2 ->
      is_nil(date_1) || is_nil(date_2) || DateTime.compare(date_1, date_2) == :lt
    end)
    |> List.first()
  end
end
