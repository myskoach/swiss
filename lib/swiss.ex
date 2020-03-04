defmodule Swiss do
  @moduledoc """
  # Swiss

  Swiss is a bundle of extensions to the standard lib. It includes several
  helper functions for dealing with standard types.

  ## API

  The root module has generic helper functions; check each sub-module's docs for
  each type's API.
  """

  @doc """
  Applies the given `func` to `value` and returns its result.

  ### Examples

      iex> Swiss.thru(42, &(12 + &1))
      54
  """
  @spec thru(value :: any(), func :: function()) :: any()
  def thru(value, func), do: func.(value)

  @doc """
  Applies the given `func` to `value` and returns value.

  ### Examples

      iex> Swiss.tap(42, &(12 + &1))
      42
  """
  @spec tap(value :: any(), func :: function()) :: any()
  def tap(value, func) do
    func.(value)
    value
  end
end
