defmodule Swiss.Ecto do
  @moduledoc """
  Generic helper functions related with Ecto.
  """

  @doc """
  Given an association field, returns whether it's preloaded.

  ### Examples
      iex> Swiss.Ecto.assoc_present?(nil)
      false

      iex> Swiss.Ecto.assoc_present?(nil, true)
      true

      iex> Swiss.Ecto.assoc_present?(%Ecto.Association.NotLoaded{})
      false

      iex> Swiss.Ecto.assoc_present?([])
      true

      iex> Swiss.Ecto.assoc_present?(MapSet.new())
      true
  """
  @spec assoc_present?(assoc :: term(), accept_nil? :: boolean) :: boolean()
  def assoc_present?(assoc, accept_nil? \\ false)
  def assoc_present?(nil, accept_nil?), do: accept_nil?
  def assoc_present?(%Ecto.Association.NotLoaded{}, _), do: false
  def assoc_present?(%_{}, _), do: true
  def assoc_present?(assoc, _) when is_list(assoc), do: true
  def assoc_present?(assoc, _), do: raise("unexpected assoc type: #{inspect(assoc)}")
end
