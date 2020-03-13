defmodule Swiss.Enum do
  @doc """
  Finds the first element in `enumerable` where its `key` equals `value`.

  ### Examples
      iex> Swiss.Enum.find_by([%{life: 11}, %{life: 42}], :life, 42)
      %{life: 42}

      iex> Swiss.Enum.find_by([%{life: 11}, %{life: 42}], :wat, 42)
      nil

      iex> Swiss.Enum.find_by([%{life: 11}, %{life: 42}], 42, :wat, 42)
      42
  """
  def find_by(enumerable, default \\ nil, key, value) do
    Enum.find(enumerable, default, fn el -> el[key] == value end)
  end

  @doc """
  Applies `cb` to all elements in `enum`, ignores the return and returns `enum`.

  ## Examples
      iex> Swiss.Enum.thru([1, 2, 3], fn a -> a + 1 end)
      [1, 2, 3]
  """
  @spec thru(Enumerable.t(), function) :: Enumerable.t()
  def thru(enum, cb) do
    :ok = Enum.each(enum, cb)
    enum
  end
end
