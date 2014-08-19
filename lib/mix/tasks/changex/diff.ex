defmodule Mix.Tasks.Changex.Diff do
  use Mix.Task

  @shortdoc "Display a changelog in the terminal"

  @moduledoc """
  Display a changelog in the terminal.

  The changelog will be generated between two commits. To generate an
  automated changelog, commits must be in the format:

      type(scope): description

  Where `type` is one of the following:

  Type           | Description
  :------------- | :-----------
  `feat`         | `a new feature`
  `fix`          | `a bug fix`
  `docs`         | `a documentation change`
  `style`        | `changing the code formatting/whitespace`
  `refactor`     | `refactoring existing code`
  `perf`         | `code that is designed to improve performance`
  `test`         | `adding a test`
  `revert`       | `removing a previous commit`
  `chore`        | `anything else - version bump, etc.`

  `scope` should be the subject of your commit, i.e. `IO.Ansi` or
  `Mix.Task`

  `description` is a short description of your commit.

  A `--dir` option can be given to show a changelog from a different
  repository.

  An optional `start` and `last` commit can be passed through. By
  default it will use the root commit as `first` and "HEAD" as `last`

  ## Examples

  Show the changes since the last tag. If no tag is available use
  the root commit.

      mix changex.diff

  Show the changes between the `v0.0.1` tag and HEAD

      mix changex.diff v0.0.1

  Show the changes between the `v0.0.1` tag and commit ade73f

      mix changex.diff v0.0.1 ade73f

  """

  def run(argv) do
    {opts, argv, _} = OptionParser.parse(argv)
    dir = opts[:dir]
    case argv do
      [first] ->  run_with_dir(dir, first, "HEAD")
      [first, last] ->  run_with_dir(dir, first, last)
      _ ->  run_with_dir(dir, nil, "HEAD")
    end
  end

  defp run_with_dir(dir, first, last) do
  first = first || default_first(dir)
    Changex.Log.log(dir, first, last)
    |> Changex.Grouper.group_by_type
    |> Changex.Grouper.group_by_scope
    |> Changex.Formatter.Terminal.output
  end

  defp default_first(dir) do
    System.cmd("git", ["describe", "--tags", "--abbrev=0"])
    |> get_tag
  end

  defp get_tag({tags, 0}) do
    tags
    |> String.split("\n")
    |> hd
  end
  defp get_tag(_), do: nil
end
