defmodule Swiss.Date do
  @moduledoc """
  Some extra functions for working with Dates that aren't in the native lib
  or on Timex.
  """

  import Swiss, only: [is_present: 1]

  @doc """
  Returns the biggest (latest) of two dates.

  ## Examples

      iex> Swiss.Date.max(~D[2022-01-22], ~D[2022-02-01])
      ~D[2022-02-01]

  """
  @spec max(Date.t(), Date.t()) :: Date.t()
  def max(date_1, date_2),
    do: max([date_1, date_2])

  @doc """
  Returns the biggest (latest) of the given list of dates.

  ## Examples

      iex> Swiss.Date.max([~D[2022-01-22], ~D[2022-02-01], ~D[2021-12-30]])
      ~D[2022-02-01]

      iex> Swiss.Date.max([~D[2021-12-30], nil])
      ~D[2021-12-30]

      iex> Swiss.Date.max([nil, nil, ~D[2022-02-01]])
      ~D[2022-02-01]
      
  """
  @spec max([Date.t()]) :: Date.t()
  def max(dates) when is_list(dates) do
    dates
    |> Enum.sort(fn date_1, date_2 ->
      is_nil(date_2) || (is_present(date_1) && Date.compare(date_1, date_2) != :lt)
    end)
    |> List.first()
  end

  @doc """
  Returns the smallest (earliest) of two dates.

  ## Examples

      iex> Swiss.Date.min(~D[2022-01-22], ~D[2022-02-01])
      ~D[2022-01-22]

  """
  @spec min(Date.t(), Date.t()) :: Date.t()
  def min(date_1, date_2),
    do: min([date_1, date_2])

  @doc """
  Returns the smallest (earliest) of the given list of datetimes.

  ## Examples

      iex> Swiss.Date.min([~D[2022-01-22], ~D[2022-02-01], ~D[2021-12-30]])
      ~D[2021-12-30]

      iex> Swiss.Date.min([~D[2022-02-01], nil])
      ~D[2022-02-01]

      iex> Swiss.Date.min([nil, nil, ~D[2022-02-01]])
      ~D[2022-02-01]

  """
  @spec min([Date.t()]) :: Date.t()
  def min(dates) when is_list(dates) do
    dates
    |> Enum.sort(fn date_1, date_2 ->
      is_nil(date_2) || (is_present(date_1) && Date.compare(date_1, date_2) == :lt)
    end)
    |> List.first()
  end
end
