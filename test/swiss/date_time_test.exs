defmodule Swiss.DateTimeTest do
  use ExUnit.Case, async: true
  doctest Swiss.DateTime

  describe "second_utc_now/0" do
    test "returns the current UTC date with second precision" do
      now = Swiss.DateTime.second_utc_now()

      assert_in_delta DateTime.to_unix(now), DateTime.to_unix(DateTime.utc_now()), 25
      assert now.utc_offset == 0
      assert now.time_zone == "Etc/UTC"
      refute now.microsecond == nil
    end
  end
end
