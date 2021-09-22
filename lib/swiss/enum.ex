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
  Finds the first element in `enumerable` where its `key` equals `value`.

  Raises if not found.

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
  Finds an element and its index in `enumerable` for which `fun` returns true.

  ### Examples

      iex> Swiss.Enum.find_both([42, 44, 46], fn num -> num == 44 end)
      {44, 1}

      iex> Swiss.Enum.find_both([42, 44, 46], fn num -> num == 45 end)
      {nil, nil}

  """
  def find_both(enumerable, fun) do
    enumerable
    |> Stream.with_index()
    |> Enum.reduce_while({nil, nil}, fn {el, idx}, {nil, nil} ->
      if fun.(el),
        do: {:halt, {el, idx}},
        else: {:cont, {nil, nil}}
    end)
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
  @spec group_by_single(Enumerable.t(), (any() -> any()), (any() -> any())) :: map()
  def group_by_single(enum, key_fn, value_fn \\ fn x -> x end) do
    enum
    |> Enum.group_by(key_fn, value_fn)
    |> Enum.reduce(%{}, fn {key, [value]}, acc -> Map.put(acc, key, value) end)
  end

  @doc """
  Calculates the average of values in an enumerable. Currently supports maps and
  lists only.

  ## Examples

      iex> Swiss.Enum.avg([1, 2, 3, 4])
      2.5

      iex> Swiss.Enum.avg([%{key: 1}, %{key: 2}, %{key: 3}, %{key: 4}], & &1.key)
      2.5

      iex> Swiss.Enum.avg(%{a: 1, b: 2, c: 3, d: 4}, &elem(&1, 1))
      2.5

      iex> Swiss.Enum.avg(%{})
      0

      iex> Swiss.Enum.avg([])
      0

  """
  @spec avg(list() | map(), (any() -> number())) :: number()
  def avg(enum, mapper \\ & &1)

  def avg([], _),
    do: 0

  def avg(list, mapper) when is_list(list) do
    Enum.reduce(list, 0, &(mapper.(&1) + &2)) / length(list)
  end

  def avg(map, _) when is_map(map) and map_size(map) == 0,
    do: 0

  def avg(map, mapper) when is_map(map) do
    Enum.reduce(map, 0, &(mapper.(&1) + &2)) / map_size(map)
  end

  @doc """
  Finds the index of a value inside an enumerable.

  ## Examples

      iex> Swiss.Enum.index_of([1, 2, 3, 4], 3)
      2

      iex> Swiss.Enum.index_of([1, 2, 3, 4], 1)
      0

      iex> Swiss.Enum.index_of([1, 2, 3, 4], 5)
      nil

  """
  @spec index_of(Enumerable.t(), any()) :: non_neg_integer() | nil
  def index_of(enum, value) do
    Enum.find_index(enum, &(&1 == value))
  end
end
