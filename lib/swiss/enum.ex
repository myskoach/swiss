defmodule Swiss.Enum do
  @moduledoc """
  A few extra functions for dealing with Enums.
  """

  @doc """
  Applies `cb` to all elements in `enum`, ignores the return and returns `enum`.

  ## Examples

      iex> Swiss.Enum.thru([1, 2, 3], fn a -> a + 1 end)
      [1, 2, 3]
  """
  @spec thru(Enumerable.t, function) :: Enumerable.t
  def thru(enum, cb) do
    Enum.map(enum, fn val ->
      cb.(val)
      val
    end)
  end
end
