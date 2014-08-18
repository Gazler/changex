defmodule Changex.Grouper do
  @moduledoc """
  This module will take a list of commits and sort them based on the
  type of the commit.
  """

  @doc """
  Take a list of `commits` in the format:

      [hash, subject | body]

  And transform them into a map based on the type of the commits. the
  map could look like:

      %{
        fix: [commit1, commit2],
        chore: [commit3, commit4]
      }
  """
  def group_by_type(commits) do
    commits |> Enum.map(&strip_body/1) |> group
  end

  defp strip_body([hash, subject | _rest]) do
      [hash, subject]
  end

  defp group(commits) do
    commits
    |> Enum.map(&get_commit_parts/1)
    |> group_commits
  end

  defp group_commits(commits) do
    group_commits(commits, %{})
  end

  defp group_commits([], dict), do: dict
  defp group_commits([commit | rest], dict) do
    type = Keyword.get(commit, :type)
    unless Dict.has_key?(dict, type) do
      dict = Dict.put(dict, type, [])
    end
    type_list = Dict.get(dict, type)
    dict = Dict.put(dict, type, type_list ++ [commit])
    group_commits(rest, dict)
  end

  defp get_commit_parts([hash, subject]) do
    format = "%{type}(%{scope}): %{description}"
    parts = Changex.SubjectSplitter.get_parts(subject, format)
    type = (Keyword.get(parts, :type) |> String.to_atom)
    parts = Keyword.put(parts, :type, type)
    Keyword.put(parts, :hash, hash)
  end
end
