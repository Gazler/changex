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

  A `--format` option can be given to alter the output format of the
  changelog. Valid options are `terminal` and `markdown`.

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
    OptionParser.parse(argv)
    |> combine_options
    |> add_default_options
    |> run_with_opts
  end

  defp run_with_opts(opts) do
    get_log(opts)
    |> Changex.Grouper.group_by_type
    |> Changex.Grouper.group_by_scope
    |> output(Keyword.get(opts, :format), Keyword.get(opts, :last))
  end

  defp output(commits, "terminal", version) do
    Changex.Formatter.Terminal.output(commits, version)
  end

  defp output(commits, "markdown", version) do
    Changex.Formatter.Markdown.output(commits, version) |> IO.puts
  end

  defp combine_options({opts, [first], _}), do: Keyword.put(opts, :first, first)
  defp combine_options({opts, [first, last], _}) do
    opts = Keyword.put(opts, :first, first)
    Keyword.put(opts, :last, last)
  end
  defp combine_options({opts, [], _}), do: opts

  defp add_default_options(opts) do
    Keyword.merge([format: "terminal"], opts)
  end

  defp get_log(opts) do
    Changex.Log.log(opts[:dir], opts[:first] || default_first(opts[:dir]), opts[:last])
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
