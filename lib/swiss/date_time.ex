defmodule Swiss.DateTime do
  @moduledoc """
  Some extra functions for working with DateTimes that aren't in the native lib
  or on Timex.
  """

  import Swiss, only: [is_present: 1]

  @doc """
  Helper method for getting "now" with second precision.
  """
  @spec second_utc_now() :: DateTime.t()
  def second_utc_now(),
    do: DateTime.utc_now() |> DateTime.truncate(:second)

  @doc """
  Returns the biggest (latest) of two datetimes.

  ## Examples

      iex> Swiss.DateTime.max(DateTime.from_unix!(1_577_664_000), DateTime.from_unix!(1_464_096_368))
      ~U[2019-12-30 00:00:00Z]

  """
  @spec max(DateTime.t(), DateTime.t()) :: DateTime.t()
  def max(date_1, date_2),
    do: max([date_1, date_2])

  @doc """
  Returns the biggest (latest) of the given list of datetimes.

  ## Examples

      iex> Swiss.DateTime.max([DateTime.from_unix!(1_577_664_000), DateTime.from_unix!(2_464_096_360), DateTime.from_unix!(1_464_096_368)])
      ~U[2048-01-31 15:12:40Z]

      iex> Swiss.DateTime.max([DateTime.from_unix!(2_464_096_360), nil])
      ~U[2048-01-31 15:12:40Z]

      iex> Swiss.DateTime.max([nil, nil, ~U[2020-11-09 09:00:50Z]])
      ~U[2020-11-09 09:00:50Z]

  """
  @spec max([DateTime.t()]) :: DateTime.t()
  def max(dates) when is_list(dates) do
    dates
    |> Enum.sort(fn date_1, date_2 ->
      is_nil(date_2) || (is_present(date_1) && DateTime.compare(date_1, date_2) != :lt)
    end)
    |> List.first()
  end

  @doc """
  Returns the smallest (earliest) of two datetimes.

  ## Examples

      iex> Swiss.DateTime.min(DateTime.from_unix!(1_577_664_000), DateTime.from_unix!(1_464_096_368))
      ~U[2016-05-24 13:26:08Z]

  """
  @spec min(DateTime.t(), DateTime.t()) :: DateTime.t()
  def min(date_1, date_2),
    do: min([date_1, date_2])

  @doc """
  Returns the smallest (earliest) of the given list of datetimes.

  ## Examples

      iex> Swiss.DateTime.min([DateTime.from_unix!(1_577_664_000), DateTime.from_unix!(2_464_096_360), DateTime.from_unix!(1_464_096_368)])
      ~U[2016-05-24 13:26:08Z]

      iex> Swiss.DateTime.min([DateTime.from_unix!(2_464_096_360), nil])
      ~U[2048-01-31 15:12:40Z]

      iex> Swiss.DateTime.min([nil, nil, ~U[2020-11-09 09:00:50Z]])
      ~U[2020-11-09 09:00:50Z]

  """
  @spec min([DateTime.t()]) :: DateTime.t()
  def min(dates) when is_list(dates) do
    dates
    |> Enum.sort(fn date_1, date_2 ->
      is_nil(date_2) || (is_present(date_1) && DateTime.compare(date_1, date_2) == :lt)
    end)
    |> List.first()
  end

  @doc """
  Converts a ISO 8601 date into a DateTime and offset.

  This is a wrapper around `DateTime.from_iso8601/2` that raises on error.

  ## Examples

      iex> Swiss.DateTime.from_iso8601!("2015-01-23T23:50:07Z")
      {~U[2015-01-23 23:50:07Z], 0}

  """
  @spec from_iso8601!(String.t()) :: {DateTime.t(), integer()}
  def from_iso8601!(iso_date, calendar \\ Calendar.ISO) do
    case DateTime.from_iso8601(iso_date, calendar) do
      {:ok, dt, offset} -> {dt, offset}
      {:error, error} -> raise error
    end
  end
end
