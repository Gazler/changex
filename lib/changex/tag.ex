defmodule Changex.Tag do
  @moduledoc """
  A module that wraps git commands to act on git tags.
  """

  @doc """
  Output the most recent tag if a tag exists, otherwise output nil.
  """

  def most_recent(dir \\ nil) do
    args = ["describe", "--tags", "--abbrev=0"]
    args = if dir, do: ["--git-dir=#{dir}.git" | args], else: args

    System.cmd("git", args)
    |> get_tag
  end

  defp get_tag({tags, 0}) do
    tags
    |> String.split("\n")
    |> hd
  end

  defp get_tag(_), do: nil
end
