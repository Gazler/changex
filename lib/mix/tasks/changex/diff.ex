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

  """

  def run([dir]) do
    run_with_dir(dir)
  end

  def run(_) do
    run_with_dir(nil)
  end

  defp run_with_dir(dir) do
    Changex.Log.log(dir)
    |> Changex.Grouper.group_by_type
    |> Changex.Grouper.group_by_scope
    |> Changex.Formatter.Terminal.output
  end
end
