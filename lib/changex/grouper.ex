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
    group(commits)
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
    map = add_scopes_to_map(Map.put(map, type, %{}), Map.get(commits, type))
    create_scope_map(rest, map, commits)
  end

  defp add_scopes_to_map(map, commits) do
    commits
    |> Enum.reduce(map, fn commit, acc -> add_scope_to_map(commit, acc) end)
  end

  defp add_scope_to_map(commit, map) do
    type = Keyword.get(commit, :type)
    scope = Keyword.get(commit, :scope)

    scope_map = default_scope_map(map, type, scope)

    commits = Map.get(scope_map, scope)
    scope_map = Map.put(scope_map, scope, commits ++ [commit])
    Map.put(map, type, scope_map)
  end

  defp default_scope_map(map, type, scope) do
    scope_map = Map.get(map, type)
    Map.put_new(scope_map, scope, [])
  end

  defp strip_body([hash, subject | _rest]) do
    [hash, subject]
  end

  defp strip_nil_commits(commit) do
    commit != []
  end

  defp group(commits) do
    non_breaking =
      commits
      |> Enum.map(&strip_body/1)
      |> Enum.map(&get_commit_parts/1)
      |> Enum.filter(&strip_nil_commits/1)

    breaking =
      commits
      |> Enum.reduce([], &extract_breaking_changes/2)

    (non_breaking ++ breaking)
    |> group_commits
  end

  defp extract_breaking_changes([hash, subject | rest], all) do
    get_commit_parts([hash, subject])
    |> get_breaking_changes(rest, all)
  end

  defp get_breaking_changes(_parts, [], all), do: all

  defp get_breaking_changes(parts, [head | tail], all) do
    case head do
      "BREAKING CHANGE: " <> message ->
        get_breaking_change_description(parts, tail, message, all)

      _other ->
        get_breaking_changes(parts, tail, all)
    end
  end

  defp get_breaking_change_description(parts, [], description, all) do
    all ++ [breaking_commit(parts, description)]
  end

  defp get_breaking_change_description(parts, commit = [head | tail], description, all) do
    case head do
      "BREAKING CHANGE: " <> _message ->
        list = all ++ [breaking_commit(parts, description)]
        get_breaking_changes(parts, commit, list)

      _other ->
        get_breaking_change_description(parts, tail, description <> "\n" <> head, all)
    end
  end

  defp breaking_commit(parts, description) do
    [
      hash: parts[:hash],
      type: :break,
      scope: parts[:scope],
      description: description |> String.trim_trailing()
    ]
  end

  defp get_commit_parts([hash, subject]) do
    format = "%{type}(%{scope}): %{description}"
    parts = Changex.SubjectSplitter.get_parts(subject, format)

    case Keyword.get(parts, :type) do
      nil ->
        []

      _ ->
        type = Keyword.get(parts, :type) |> String.to_atom()
        parts = Keyword.put(parts, :type, type)
        Keyword.put(parts, :hash, hash)
    end
  end

  defp group_commits(commits) do
    group_commits(commits, %{})
  end

  defp group_commits([], dict), do: dict

  defp group_commits([commit | rest], dict) do
    type = Keyword.get(commit, :type)
    dict = Map.put_new(dict, type, [])

    type_list = Map.get(dict, type)
    dict = Map.put(dict, type, type_list ++ [commit])
    group_commits(rest, dict)
  end
end
