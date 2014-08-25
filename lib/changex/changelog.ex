defmodule Changex.Changelog do
  @moduledoc """
  This module is used to read and manipulate a changelog file.
  """

  @doc """
  Get the changelog without the current section.

  If a `path` containing the following changelog is given with a `tag`
  of v0.0.2

      # 0.0.3-dev

      ...

      # v0.0.2

      ...

      # v0.0.1

      ...

  Then the output will be:

      # v0.0.2

      ...

      # v0.0.1

      ...

  """
  def read(path, tag) do
    {:ok, contents} = File.read(path)
    lines = contents |> String.split("\n")
    lines
    |> Enum.drop_while(fn (line) -> last_version(line, tag) end)
    |> Enum.join("\n")
  end

  defp last_version(line, tag) do
    !String.match?(line, ~r/#{tag}/)
  end


end
