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
  @spec defaults(map(), map() | keyword()) :: map()
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
  @spec from_struct(struct | nil) :: map() | nil
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
  @spec to_string_keys(map()) :: map()
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
  @spec indif_fetch!(map(), atom()) :: any()
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

  `pred` can also be a boolean.

  ## Examples

      iex> Swiss.Map.put_if(%{life: 42}, :life, 22)
      %{life: 22}

      iex> Swiss.Map.put_if(%{life: 42}, :life, nil)
      %{life: 42}

      iex> Swiss.Map.put_if(%{life: 42}, :life, nil, &is_nil/1)
      %{life: nil}

      iex> Swiss.Map.put_if(%{life: 42}, :life, 22, &(&1 < 55))
      %{life: 22}

      iex> Swiss.Map.put_if(%{life: 42}, :life, 30, true)
      %{life: 30}

      iex> Swiss.Map.put_if(%{life: 42}, :life, 30, false)
      %{life: 42}
  """
  @spec put_if(map(), any(), any(), (any() -> boolean()) | boolean()) :: map()
  def put_if(map, key, value, pred \\ fn v -> !is_nil(v) end)

  def put_if(map, key, value, pred) when is_function(pred, 1),
    do: put_if(map, key, value, pred.(value))

  def put_if(map, key, value, condition) when is_boolean(condition) do
    if condition,
      do: Map.put(map, key, value),
      else: map
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
  Deep merges two maps. Only maps are merged, all other types are overridden.

  ## Examples

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

  @doc """
  Cuts off a map at the given depth.

  This works for nested maps, but also maps nested in lists and tuples.

  ## Options

  * `max_depth´: Depth at which to cut off at. Defaults to 1.
  * `placeholder`: Map values that would exceed the maximum depth are replaced by a placeholder. Defaults to an empty map.

  ## Examples

      iex> Swiss.Map.cut_depth(%{a: 1, b: 2})
      %{a: 1, b: 2}

      iex> Swiss.Map.cut_depth(%{a: %{c: 3, d: 4}, b: 2})
      %{a: %{}, b: 2}

      iex> Swiss.Map.cut_depth(%{a: %{c: 3, d: 4}, b: 2}, max_depth: 2)
      %{a: %{c: 3, d: 4}, b: 2}

      iex> Swiss.Map.cut_depth(%{a: %{c: 3, d: 4}, b: 2}, placeholder: "%{...}")
      %{a: "%{...}", b: 2}

      iex> Swiss.Map.cut_depth(%{a: [1, 2], b: [%{a: 2}], c: {1, 2}, d: {%{a: 5}}})
      %{a: [1, 2], b: [%{}], c: {1, 2}, d: {%{}}}
  """
  @spec cut_depth(map :: map(), opts :: cut_depth_opts) :: map
        when cut_depth_opts: [max_depth: non_neg_integer(), placeholder: any()]
  def cut_depth(map, opts \\ []) when is_map(map) do
    max_depth = opts[:max_depth] || 1
    placeholder = opts[:placeholder] || %{}

    cut_depth(map, max_depth, placeholder)
  end

  defp cut_depth(value, max_depth, placeholder, depth \\ 1)

  defp cut_depth(lst, max_depth, placeholder, depth) when is_list(lst),
    do: Enum.map(lst, &cut_depth(&1, max_depth, placeholder, depth))

  defp cut_depth(map, max_depth, placeholder, depth) when is_map(map) do
    if depth > max_depth do
      placeholder
    else
      map
      |> Enum.map(fn {key, map_value} ->
        {key, cut_depth(map_value, max_depth, placeholder, depth + 1)}
      end)
      |> Enum.into(%{})
    end
  end

  defp cut_depth(tuple, max_depth, placeholder, depth) when is_tuple(tuple) do
    tuple
    |> Tuple.to_list()
    |> cut_depth(max_depth, placeholder, depth)
    |> List.to_tuple()
  end

  defp cut_depth(value, _max_depth, _placeholder, _depth),
    do: value

  @doc """
  Appplies an updater function to all keys in the given map.

  The updater function receives a `{key, value}` tuple and may return a new
  value, or a new `{key, value}` tuple.

  ## Examples

      iex> Swiss.Map.update_all(%{a: 1, b: 2}, &(elem(&1, 1) * 2))
      %{a: 2, b: 4}

      iex> Swiss.Map.update_all(%{a: 1, b: 2}, &{Atom.to_string(elem(&1, 0)), elem(&1, 1) * 3})
      %{"a" => 3, "b" => 6}

  """
  @spec update_all(map(), ({any(), any()} -> {any(), any()} | any())) :: map()
  def update_all(map, updater) do
    Enum.reduce(map, %{}, fn {key, value}, acc ->
      case updater.({key, value}) do
        {new_key, new_value} -> Map.put(acc, new_key, new_value)
        new_value -> Map.put(acc, key, new_value)
      end
    end)
  end
end
