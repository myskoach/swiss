defmodule Swiss.Map do
  @moduledoc """
  A few extra functions to deal with Maps.
  """

  @doc """
  Applies defaults to a map.

  ## Examples
      iex> Swiss.Map.defaults(%{a: 42}, %{b: 12})
      %{a: 42, b: 12}

      iex> Swiss.Map.defaults(%{a: 42}, %{a: 44, b: 12})
      %{a: 42, b: 12}

      iex> Swiss.Map.defaults(%{a: 42, c: nil}, [a: nil, b: 12, c: 13])
      %{a: 42, b: 12, c: nil}
  """
  @spec defaults(Map.t(), Map.t() | keyword()) :: Map.t()
  def defaults(map, defaults) when is_list(defaults),
    do: defaults(map, Enum.into(defaults, %{}))

  def defaults(map, defaults) when is_map(defaults),
    do: Map.merge(defaults, map)

  @doc """
  Wrapper around `Map.from_struct/1` that tolerates `nil`.

  ## Examples
      iex> Swiss.Map.from_struct(nil)
      nil

      iex> Swiss.Map.from_struct(%{__struct__: SomeStruct, life: 42})
      %{life: 42}
  """
  @spec from_struct(struct | nil) :: Map.t() | nil
  def from_struct(nil), do: nil
  def from_struct(struct), do: Map.from_struct(struct)

  @doc """
  Converts an atom-keyed map into a string-keyed map.

  ## Examples
      iex> Swiss.Map.to_string_keys(%{life: 42})
      %{"life" => 42}

      iex> Swiss.Map.to_string_keys(%{"life" => 42, death: 27})
      %{"life" => 42, "death" => 27}
  """
  @spec to_string_keys(Map.t()) :: Map.t()
  def to_string_keys(map) do
    map
    |> Map.to_list()
    |> Stream.map(fn
      {key, value} when is_atom(key) -> {Atom.to_string(key), value}
      entry -> entry
    end)
    |> Enum.into(%{})
  end

  @doc """
  Fetches a value from a map with indifferent access, i.e. given an atom,
  returns the value that is keyed by that atom, or by its string equivalent.

  If both atom and String keys exist in the map, the atom's value is returned.

  ## Examples
      iex> Swiss.Map.indif_fetch!(%{life: 42}, :life)
      42

      iex> Swiss.Map.indif_fetch!(%{"life" => 42}, :life)
      42

      iex> Swiss.Map.indif_fetch!(%{:life => 42, "life" => 64}, :life)
      42

      iex> Swiss.Map.indif_fetch!(%{}, :life)
      ** (KeyError) key :life not found in: %{}
  """
  @spec indif_fetch!(Map.t(), atom()) :: any()
  def indif_fetch!(map, key) when is_atom(key) do
    Map.get_lazy(map, key, fn ->
      string_key = Atom.to_string(key)

      if Map.has_key?(map, string_key) do
        map[string_key]
      else
        raise KeyError, "key #{inspect(key)} not found in: #{inspect(map)}"
      end
    end)
  end

  @doc """
  Runs `Map.put/3` only if `pred` returns truthy when called on the value.

  The default behavior is to put unless the value is `nil`.

  ## Examples
      iex> Swiss.Map.put_if(%{life: 42}, :life, 22)
      %{life: 22}

      iex> Swiss.Map.put_if(%{life: 42}, :life, nil)
      %{life: 42}

      iex> Swiss.Map.put_if(%{life: 42}, :life, nil, &is_nil/1)
      %{life: nil}

      iex> Swiss.Map.put_if(%{life: 42}, :life, 22, &(&1 < 55))
      %{life: 22}
  """
  @spec put_if(map(), any(), any(), (any() -> boolean())) :: map()
  def put_if(map, key, value, pred \\ fn v -> !is_nil(v) end) do
    if pred.(value) do
      Map.put(map, key, value)
    else
      map
    end
  end

  @doc """
  Runs `Map.put/3` only if `cond` is truthy. Unlike `Swiss.Map.put_if/4`, takes
  a function that is called when the condition passes, that should return the
  value to insert in the map.

  ## Examples
      iex> Swiss.Map.put_if_lazy(%{life: 42}, :life, fn -> 12 end, true)
      %{life: 12}

      iex> Swiss.Map.put_if_lazy(%{life: 42}, :life, fn -> 12 end, false)
      %{life: 42}
  """
  @spec put_if_lazy(map(), any(), (() -> any()), any()) :: map()
  def put_if_lazy(map, key, value_fn, condition) do
    if condition do
      Map.put(map, key, value_fn.())
    else
      map
    end
  end

  @doc """
  Deep merges two maps. Only maps are merged, all other types are overriden.

      iex> Swiss.Map.deep_merge(%{user: %{id: 42}}, %{user: %{name: "João"}})
      %{user: %{id: 42, name: "João"}}

      iex> Swiss.Map.deep_merge(
      ...> %{user: %{id: 42, message: %{id: 22}}},
      ...> %{user: %{message: %{text: "hi"}}},
      ...> 1
      ...> )
      %{user: %{id: 42, message: %{text: "hi"}}}

      iex> Swiss.Map.deep_merge(
      ...> %{user: %{id: 42}, messages: [%{id: 1}]},
      ...> %{user: %{id: 30, age: 40}, messages: [%{id: 2}]}
      ...> )
      %{user: %{id: 30, age: 40}, messages: [%{id: 2}]}
  """
  @spec deep_merge(map(), map(), non_neg_integer() | :infinity) :: map()
  def deep_merge(map_dest, map_src, max_depth \\ :infinity) do
    deep_merge(map_dest, map_src, max_depth, 0)
  end

  defp deep_merge(map_dest, map_src, max_depth, depth)
       when is_number(max_depth) and max_depth <= depth do
    Map.merge(map_dest, map_src)
  end

  defp deep_merge(map_dest, map_src, max_depth, depth) do
    Map.merge(map_dest, map_src, fn
      _key, value_dest, value_src when is_map(value_dest) and is_map(value_src) ->
        deep_merge(value_dest, value_src, max_depth, depth + 1)

      _key, _value_dest, value_src ->
        value_src
    end)
  end
end
