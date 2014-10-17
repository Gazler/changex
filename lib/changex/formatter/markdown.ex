defmodule Changex.Formatter.Markdown do

  @moduledoc """
  Format changelog to the terminal in markdown format.
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

  And return a string in the format:

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
  def format(commits, version \\ nil, opts \\ []) do
    heading(version) <> types(commits, opts)
  end

  defp heading(version) do
    "# #{(version || Keyword.get(Mix.Project.config, :version))}\n"
  end

  defp types(commits, opts) do
    valid_types
    |> Enum.filter(fn (type) -> Dict.get(commits, type) end)
    |> Enum.map(fn (type) -> build_type(type, Dict.get(commits, type), opts) end)
    |> Enum.join("\n")
  end

  defp build_type(type, commits, opts) when is_map(commits) do
    "\n## #{type |> lookup_type}\n\n" <> build_commits(commits, opts)
  end
  defp build_type(type, _, opts), do: nil

  defp build_commits(commits, opts) do
    commits
    |> Enum.map(fn (commit) -> build_commit_scope(commit, opts) end)
    |> Enum.join("\n")
  end

  defp build_commit_scope({scope, commits}, opts) do
    response = " * **#{to_string(scope)}**"
    commits
    |> Enum.reduce(response, fn (commit, acc) -> build_commit(commit, acc, opts) end)
  end

  defp build_commit(commit, acc, opts) do
    hash = get_hash(commit, opts)
    description = Keyword.get(commit, :description) |> String.split("\n") |> Enum.join("\n    ")
    acc <> "\n  * #{description} (#{hash})"
  end

  defp get_hash(commit, opts) do
    hash = Keyword.get(commit, :hash)
    if Keyword.has_key?(opts, :github) do
      "[#{hash}](https://github.com/#{Keyword.get(opts, :github)}/commit/#{hash})"
    else
      hash
    end
  end

  defp valid_types, do: [:fix, :feat, :perf, :break]

  defp lookup_type(:fix), do: "Bug Fixes"
  defp lookup_type(:feat), do: "Features"
  defp lookup_type(:perf), do: "Performance Improvements"
  defp lookup_type(:break), do: "Breaking Changes"

end
