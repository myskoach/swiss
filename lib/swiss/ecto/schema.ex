defmodule Swiss.Ecto.Schema do
  @moduledoc """
  Helper functions for handling ecto schemas.
  """

  @doc "Converts an Ecto struct into a map, including embeds"
  @spec to_map(struct()) :: map()
  def to_map(%_{} = schema) do
    schema
    |> Map.from_struct()
    |> Enum.filter(fn
      {_, %Ecto.Association.NotLoaded{}} -> false
      {_, nil} -> false
      _ -> true
    end)
    |> Enum.map(fn
      {key, lst} when is_list(lst) ->
        {key, Enum.map(lst, &Swiss.Ecto.Schema.to_map/1)}

      {key, struct = %_{}} ->
        {key, Swiss.Ecto.Schema.to_map(struct)}

      {key, value} ->
        {key, value}
    end)
    |> Enum.into(%{})
  end

  def to_map(val),
    do: val
end
