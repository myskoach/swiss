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
end
