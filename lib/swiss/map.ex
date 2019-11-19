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
end
