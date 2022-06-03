defmodule Swiss.List do
  @doc """
  Replaces a value in a list at the position indicated by the given predicate.

  The predicate receives list values as its sole argument and should return true
  when the value to be replaced is found.

  When a value isn't found, `list` is returned as is.

  ## Examples
      iex> Swiss.List.replace_with([1, 2, 3], 5, &(&1 == 2))
      [1, 5, 3]

      iex> Swiss.List.replace_with([1, 2, 3], 5, &(&1 == 5))
      [1, 2, 3]
  """
  @spec replace_with(list :: [any()], value :: any(), finder :: (any() -> boolean())) :: [any()]
  def replace_with(list, value, finder) when is_list(list) and is_function(finder, 1) do
    case Enum.find_index(list, finder) do
      nil -> list
      idx -> List.replace_at(list, idx, value)
    end
  end
end
