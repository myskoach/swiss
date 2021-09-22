defmodule Swiss.Struct do
  @moduledoc """
  A few extra functions to work with Structs.
  """

  @doc """
  Converts a struct into a string-key map (eg: params from post).

  ## Examples

      iex> Swiss.Struct.to_params_map(%Swiss.TestStruct{life: 42})
      %{"life" => 42}

  """
  @spec to_params_map(struct) :: Map.t
  def to_params_map(struct) do
    struct
    |> Map.from_struct()
    |> Swiss.Map.to_string_keys()
  end
end
