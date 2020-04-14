defmodule Swiss.Enum do
  @moduledoc """
  Helper functions for dealing with Enumerables.
  """

  alias Swiss.Enum.KeyValueError

  @doc """
  Finds the first element in `enumerable` where its `key` equals `value`.
  Returns `default` if not found.

  ### Examples
      iex> Swiss.Enum.find_by([%{life: 11}, %{life: 42}], :life, 42)
      %{life: 42}

      iex> Swiss.Enum.find_by([%{life: 11}, %{life: 42}], :wat, 42)
      nil

      iex> Swiss.Enum.find_by([%{life: 11}, %{life: 42}], 42, :wat, 42)
      42

      iex> Swiss.Enum.find_by([%Swiss.TestStruct{life: 42}], :life, 42)
      %Swiss.TestStruct{life: 42}
  """
  @spec find_by(Enumerable.t(), any(), any(), any()) :: any()
  def find_by(enumerable, default \\ nil, key, value) do
    Enum.find(enumerable, default, fn
      %_{} = el -> Map.get(el, key) == value
      el -> el[key] == value
    end)
  end

  @doc """
  Finds the first element in `enumerable` where its `key` equals `value`. Raises
  if not found.

  ### Examples
      iex> Swiss.Enum.find_by!([%{life: 11}, %{life: 42}], :life, 42)
      %{life: 42}

      iex> Swiss.Enum.find_by!([%{life: 11}, %{life: 42}], :wat, 42)
      ** (Swiss.Enum.KeyValueError) key :wat with value 42 not found in: [%{life: 11}, %{life: 42}]
  """
  @spec find_by!(Enumerable.t(), any(), any()) :: any()
  def find_by!(enumerable, key, value) do
    case Swiss.Enum.find_by(enumerable, :not_found, key, value) do
      :not_found -> raise %KeyValueError{key: key, value: value, term: enumerable}
      el -> el
    end
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

  @doc """
  Same as `Enum.group_by/3` but expects each group to have a single element, and
  therefore returns only that element per key, instead of a list.

  ## Examples
      iex> Swiss.Enum.group_by_single(
      ...>   [%{k: "life", v: 42}, %{k: "death", v: 13}, %{k: "ooo", v: 0}],
      ...>   & &1.k,
      ...>   & &1.v
      ...> )
      %{"life" => 42, "death" => 13, "ooo" => 0}
  """
  def group_by_single(enum, key_fn, value_fn \\ fn x -> x end) do
    enum
    |> Enum.group_by(key_fn, value_fn)
    |> Enum.reduce(%{}, fn {key, [value]}, acc -> Map.put(acc, key, value) end)
  end
end
