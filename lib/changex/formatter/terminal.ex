defmodule Changex.Formatter.Terminal do

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
  def output(commits) do
    types
    |> Enum.each(fn (type) -> output_type(type, Dict.get(commits, type)) end)
  end

  defp output_type(type, commits) when is_map(commits) do
    IO.puts "#{IO.ANSI.cyan} #{lookup(type)} #{IO.ANSI.reset}"
    IO.puts ""
    commits
    |> Enum.each(&output_commit_scope/1)
  end
  defp output_type(type, _), do: nil

  defp output_commit_scope({scope, commits}) do
    IO.puts " #{IO.ANSI.magenta} #{to_string(scope)} #{IO.ANSI.reset}"
    commits
    |> Enum.each(&output_commit/1)
    IO.puts ""
  end

  defp output_commit(commit) do
    "   * #{Keyword.get(commit, :description)} - #{Keyword.get(commit, :hash)}"
    |> IO.puts
  end

  defp types, do: [:fix, :feat, :perf]

  defp lookup(:fix), do: "Bug Fixes"
  defp lookup(:feat), do: "Features"
  defp lookup(:perf), do: "Performance Improvements"

end
