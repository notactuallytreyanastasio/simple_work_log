defmodule WorkLogTest do
  use ExUnit.Case

  test "can get the given years with entries, giving integers if asked" do
    assert WorkLog.years(:integer) == [2022, 2023, 2024, 2025, 2026]
  end

  test "can get the given years with entries, defaulting to strings" do
    assert WorkLog.years() == ~w(2022 2023 2024 2025 2026)
  end
end
