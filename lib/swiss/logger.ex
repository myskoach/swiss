defmodule Swiss.Logger do
  @doc """
  Deep merges the given metadata into the existing logger's metadata.

  Use this to extend existing context objects, for example.
  """
  @spec deep_merge_metadata(module(), map() | keyword()) :: :ok
  def deep_merge_metadata(logger \\ Logger, metadata)

  def deep_merge_metadata(logger, metadata) when is_list(metadata),
    do: deep_merge_metadata(logger, Enum.into(metadata, %{}))

  def deep_merge_metadata(logger, metadata) when is_map(metadata) do
    logger.metadata()
    |> Enum.into(%{})
    |> Swiss.Map.deep_merge(metadata)
    |> Enum.into([])
    |> logger.metadata()
  end
end
