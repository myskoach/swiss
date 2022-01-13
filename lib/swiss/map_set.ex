defmodule Swiss.MapSet do
  @moduledoc """
  Helper functions for MapSets.
  """

  @doc """
  Toggles a value within a MapSet (adds if missing, removes if present).

  ## Examples

      iex> Swiss.MapSet.toggle MapSet.new(), 42
      #MapSet<[42]>

      iex> Swiss.MapSet.toggle MapSet.new([42]), 42
      #MapSet<[]>

      iex> Swiss.MapSet.toggle MapSet.new([42]), 55
      #MapSet<[42, 55]>
  """
  @spec toggle(MapSet.t(), any()) :: MapSet.t()
  def toggle(mapset, value) do
    if MapSet.member?(mapset, value),
      do: MapSet.delete(mapset, value),
      else: MapSet.put(mapset, value)
  end
end
