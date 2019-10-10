defmodule Swiss.DateTime do
  @doc """
  Helper method for getting "now" with second precision.
  """
  @spec second_utc_now() :: DateTime.t
  def second_utc_now(),
    do: DateTime.utc_now() |> DateTime.truncate(:second)
end
