defmodule Swiss.LoggerTest do
  use ExUnit.Case, async: true

  require Logger

  describe "deep_merge_metadata/2" do
    setup do
      Logger.reset_metadata()
    end

    test "deep merges maps in metadata" do
      Logger.metadata(%{context: %{user: %{id: 42}}})

      # Sanity check
      assert Logger.metadata() == [context: %{user: %{id: 42}}]

      Swiss.Logger.deep_merge_metadata(Logger, %{context: %{user: %{name: "João"}}})

      assert Logger.metadata() == [context: %{user: %{id: 42, name: "João"}}]
    end
  end
end
