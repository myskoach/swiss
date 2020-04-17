defmodule Swiss.Map do
  @moduledoc """
  A few extra functions to deal with Maps.
  """

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
end
