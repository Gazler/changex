defmodule Changex.Formatter.Terminal do
  use Changex.Formatter

  @moduledoc """
  Output the formatted changelog to the terminal.
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

  And output them to the terminal in the following format:

      Bug Fixes

       Scope 1
        * commit 1 - hash
        * commit 2 - hash

       Scope 2
        * commit 5 - hash
        * commit 6 - hash

      Features

       Scope 1
        * commit 3 - hash
        * commit 4 - hash

       Scope 2
        * commit 7 - hash
        * commit 8 - hash

  """
  def output(commits, version \\ nil) do
    IO.ANSI.Docs.print_headings([version || current_version()])

    types()
    |> Enum.each(fn type -> output_type(type, Map.get(commits, type)) end)
  end

  defp output_type(type, commits) when is_map(commits) do
    "# #{type |> lookup}" |> IO.ANSI.Docs.print("text/markdown")

    commits
    |> Enum.each(&output_commit_scope/1)
  end

  defp output_type(_type, _), do: nil

  defp output_commit_scope({scope, commits}) do
    output = "## #{to_string(scope)}\n"

    commits
    |> Enum.reduce(output, fn commit, acc -> build_commits(commit, acc) end)
    |> IO.ANSI.Docs.print("text/markdown")
  end

  defp build_commits(commit, acc) do
    hash = Keyword.get(commit, :hash) |> String.slice(0, 8)
    message = String.replace(Keyword.get(commit, :description), "_", "\\_")
    acc <> "  * #{message} - `#{hash}`\n"
  end

  defp types, do: [:fix, :feat, :perf, :break]

  defp lookup(:fix), do: "Bug Fixes"
  defp lookup(:feat), do: "Features"
  defp lookup(:perf), do: "Performance Improvements"
  defp lookup(:break), do: "Breaking Changes"
end
