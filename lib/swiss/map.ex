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
  @spec from_struct(struct | nil) :: Map.t | nil
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
  @spec to_string_keys(Map.t) :: Map.t
  def to_string_keys(map) do
    map
    |> Map.to_list()
    |> Stream.map(fn
      {key, value} when is_atom(key) -> {Atom.to_string(key), value}
      entry -> entry
    end)
    |> Enum.into(%{})
  end
end
