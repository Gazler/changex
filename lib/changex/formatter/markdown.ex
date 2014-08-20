defmodule Changex.Formatter.Markdown do

  @moduledoc """
  commit the formatted changelog to the terminal in markdown format.
  """

  @doc """
  Take a map of commits in the following format:

      %{
        fix: %{
          scope1: [commit1, commit2],
          scope2: [commit5, commit6]
        }
        feat: %{
          scope1: [commit3, commit4],
          scope2: [commit7, commit8]
        }
      }

  And commit them to the terminal in the following format:

      # v0.0.1

      ## Bug Fixes

       * **Scope 1**
        * commit 1 - hash
        * commit 2 - hash
      *  **Scope 2**
        * commit 5 - hash
        * commit 6 - hash

      ## Features

       * **Scope 1**
        * commit 3 - hash
        * commit 4 - hash
       * **Scope 2**
        * commit 7 - hash
        * commit 8 - hash

  """
  def output(commits, version \\ nil) do
    heading(version) <> types(commits)
  end

  defp heading(version) do
    "# #{(version || Keyword.get(Mix.Project.config, :version))}\n"
  end

  defp types(commits) do
    valid_types
    |> Enum.map(fn (type) -> build_type(type, Dict.get(commits, type)) end)
    |> Enum.join("\n")
  end

  defp build_type(type, commits) when is_map(commits) do
    "\n## #{type |> lookup_type}\n\n" <> build_commits(commits)
  end
  defp build_type(type, _), do: nil

  defp build_commits(commits) do
    commits
    |> Enum.map(&build_commit_scope/1)
    |> Enum.join("\n")
  end

  defp build_commit_scope({scope, commits}) do
    response = " * **#{to_string(scope)}**"
    commits
    |> Enum.reduce(response, fn (commit, acc) -> build_commit(commit, acc) end)
  end

  defp build_commit(commit, acc) do
    hash = Keyword.get(commit, :hash)
    acc <> "\n  * #{Keyword.get(commit, :description)} (#{hash})"
  end

  defp valid_types, do: [:fix, :feat, :perf]

  defp lookup_type(:fix), do: "Bug Fixes"
  defp lookup_type(:feat), do: "Features"
  defp lookup_type(:perf), do: "Performance Improvements"

end
