defmodule WorkLogTest do

  use ExUnit.Case

  @moduletag timeout: :infinity

  @year 2022
  @month 2

  test "can get the given years with entries, giving integers if asked" do
    assert WorkLog.years(:integer) == [2022, 2023, 2024, 2025, 2026]
  end

  test "can get the given years with entries, defaulting to strings" do
    assert WorkLog.years() == ~w(2022 2023 2024 2025 2026)
  end

  test "it can get the posts for a given year/month combo if they exist" do
    [first_post | _] = WorkLog.post_files_by_month(@year, @month)
    assert first_post in ["priv/years/2022/02/02.md"]
  end

  test "it returns a proper error if the there are no posts in that month or year" do
    {:error, e} = WorkLog.post_files_by_month(2099, @month)
    assert e == "error, either month or year folder does not exist in priv"
  end

  test "it can get HTML files for a month and year" do
    res = WorkLog.html_for_month_and_year(@year, @month)
    expected = ["<h1>\nA starting point</h1>\n<h2>\nLets see how this works</h2>\n<p>\nIt is where I would normally keep some notes</p>\n"]
    assert res == expected
  end

  test "generates HTML for a whole year" do
    [
      [
        _january,
        [feb_2_html | _rest],
        _march,
        _april,
        _may,
        _june,
        _july,
        _august,
        _september,
        _october,
        _novemmber,
        _december,
      ],
      _twenty_twenty_three,
      _twenty_twenty_four,
      _twenty_twenty_five,
      _twenty_twenty_six,
    ] = WorkLog.generate_years_posts(2022)
    expected_html = "<h1>\nA starting point</h1>\n<h2>\nLets see how this works</h2>\n<p>\nIt is where I would normally keep some notes</p>\n"
    assert feb_2_html == expected_html
  end
end
