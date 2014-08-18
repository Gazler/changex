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

  @doc """
  Take a map of `commits` in the format:

      %{
        fix: [commit1, commit2],
        chore: [commit3, commit4]
      }


  And transform them into a map based on the scope of the commits. the
  map could look like:

      %{
        fix: %{
          scope1: [commit1, commit2],
          scope2: [commit5, commit6]
        }
        chore: %{
          scope1: [commit3, commit4],
          scope2: [commit7, commit8]
        }
      }
  """

  def group_by_scope(commits) do
    Map.keys(commits)
    |> create_scope_map(%{}, commits)
  end

  defp create_scope_map([], map, _), do: map
  defp create_scope_map([type | rest], map, commits) do
    map = add_scopes_to_map(Dict.put(map, type, %{}), Dict.get(commits, type))
    create_scope_map(rest, map, commits)
  end

  defp add_scopes_to_map(map, commits) do
    commits
    |> Enum.reduce(map, fn (commit, acc) -> add_scope_to_map(commit, acc) end)
  end

  defp add_scope_to_map(commit, map) do
    type = Keyword.get(commit, :type)
    scope = Keyword.get(commit, :scope)

    scope_map = default_scope_map(map, type, scope)

    commits = Dict.get(scope_map, scope)
    scope_map = Dict.put(scope_map, scope, commits ++ [commit])
    Dict.put(map, type, scope_map)
  end

  defp default_scope_map(map, type, scope) do
    scope_map = Dict.get(map, type)
    unless Dict.has_key?(scope_map, scope) do
      scope_map = Dict.put(scope_map, scope, [])
    end
    scope_map
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
