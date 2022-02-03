defmodule WorkLog do
  @moduledoc """
  Tooling to compile the documents as structured in the priv folder

  I probably will just wrap this all up as an escript and/or throw a makefile around it
  """

  @valid_months [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]

  @valid_years [
    2022,
    2023,
    2024,
    2025,
    2026
  ]
  @header """
  <html>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
    <body>
  """

  def write_index do
    content = make_all_posts_single_file |> Enum.join("\n<!-- this breaks between a year seemingly -->") |> Kernel.<> "</body></html>"
    final = @header <> content
    File.write("priv/index.html", final)
  end

  def make_all_posts_single_file do
    @valid_years
    |> generate_years_posts
    |> Enum.map(fn all_years_posts ->
      case all_years_posts do
        [] ->
          ""

        year_of_posts ->
          res =
            year_of_posts
            |> Enum.map(fn month_of_posts ->
              case month_of_posts do
                [] -> "\n<!--this day did not have a post -->"
                posts -> posts |> Enum.join("\n<!-- end of post -->")
              end
            end)
            |> List.flatten()
            |> Enum.join("\n")
      end
    end)
  end

  def valid_months, do: @valid_months
  def valid_years, do: @valid_years

  def generate_years_posts(year) do
    @valid_years
    |> Enum.map(fn year ->
      @valid_months
      |> Enum.map(&__MODULE__.html_for_month_and_year(year, &1))
    end)
  end

  @doc """
  Generates HTML for a given year/months posts

  From here, you can do whatever you please with the content

  The default high level API will construct one large index.html file

  Once I make it smarter, they will each become a route and be a part of a Plug
  that can be served however you please.

  The V1 here just spits out an index.html and isnt there yet
  """
  @spec html_for_month_and_year(pos_integer(), pos_integer()) ::
          {:ok, [String.t()]} | {:error, any()}
  def html_for_month_and_year(year, month) do
    case post_files_by_month(year, month) do
      {:error, e} ->
        {:error, e}

      result ->
        result
        |> Enum.map(&File.read!/1)
        |> Enum.map(&Earmark.as_html!/1)
        |> Enum.map(fn html -> html <> "<hr><hr><hr>" end)
    end
  end

  @doc """
  Get the priv-based path to all entries for a given month or year

  Met to be composed with markdown conversion, which is the next step
  """
  @spec post_files_by_month(pos_integer(), pos_integer()) :: {:ok, [String.t()]} | {:error, any}
  def post_files_by_month(year, month)
      when is_integer(year) and
             month in @valid_months and
             year in @valid_years do
    case Enum.any?(years(:integer), fn y -> year == y end) do
      true ->
        month_string = month_integer_folder_name(month)

        case File.ls("priv/years/#{year}/#{month_string}") do
          {:ok, posts} ->
            posts
            |> Enum.map(fn post_file -> "priv/years/#{year}/#{month_string}/#{post_file}" end)

          error ->
            error
        end

      # somehow this branch isnt being hit, but who cares check later
      false ->
        {:error, "Invalid year provided"}
    end
  end

  @doc false
  def post_files_by_month(_, _) do
    {:error, "error, either month or year folder does not exist in priv"}
  end

  @doc false
  @spec years(atom()) :: [pos_integer()] | {:error, any}
  def years(:integer) do
    case File.ls("priv/years") do
      {:ok, files} -> files |> Enum.map(&String.to_integer/1) |> Enum.sort()
      {:error, _} -> {:error, "directory priv/years does not exist"}
    end
  end

  @spec years() :: [String.t()] | {:error, any}
  @doc false
  def years() do
    case File.ls("priv/years") do
      {:ok, files} -> files |> Enum.sort()
      {:error, _} -> {:error, "directory priv/years does not exist"}
    end
  end

  @spec month_integer_folder_name(pos_integer()) :: String.t()
  def month_integer_folder_name(1), do: "01"
  def month_integer_folder_name(2), do: "02"
  def month_integer_folder_name(3), do: "03"
  def month_integer_folder_name(4), do: "04"
  def month_integer_folder_name(5), do: "05"
  def month_integer_folder_name(6), do: "06"
  def month_integer_folder_name(7), do: "07"
  def month_integer_folder_name(8), do: "08"
  def month_integer_folder_name(9), do: "09"
  def month_integer_folder_name(10), do: "10"
  def month_integer_folder_name(11), do: "11"
  def month_integer_folder_name(12), do: "12"
end
