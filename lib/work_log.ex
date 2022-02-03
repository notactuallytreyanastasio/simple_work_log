defmodule WorkLog do
  @moduledoc """
  Tooling to compile the documents as structured in the priv folder

  I probably will just wrap this all up as an escript and/or throw a makefile around it
  """

  @doc """
  Returns the years which there are entries for
  """

  @spec years(atom()) :: [pos_integer()] | {:error, any}
  def years(:integer) do
    case File.ls("priv/years") do
      {:ok, files} -> files |> Enum.map(&String.to_integer/1) |> Enum.sort()
      {:error, _} -> {:error, "directory priv/years does not exist"}
    end
  end

  @spec years() :: [String.t()] | {:error, any}
  def years() do
    case File.ls("priv/years") do
      {:ok, files} -> files |> Enum.sort()
      {:error, _} -> {:error, "directory priv/years does not exist"}
    end
  end

end
