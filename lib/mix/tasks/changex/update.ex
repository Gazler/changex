defmodule Mix.Tasks.Changex.Update do
  use Mix.Task

  @shortdoc "Write an update to a file."

  @moduledoc """
  Write an update to the changelog file. Defaults to CHANGELOG.md

  A `--format` argument can be passed to output the changelog in a
  different format.

  A `--file` option can be given to change the output file.

  A `--github` option can be given link to a GitHub repository when the
  commit hash is displayed. This is in the format `username/repo`.

  ## Examples

  Update the changelog using the default format of `markdown` and
  file of `CHANGELOG.md`

      mix changex.update

  Update using elixir formatter and a file call CHANGES.markdown

      mix changex.update --format elixir --file CHANGES.markdown

  """

  def run(argv) do
    {opts, _, _} = OptionParser.parse(argv, switches: [format: :string, file: :string, gitgub: :string])

    opts
    |> add_default_options()
    |> run_with_opts()
  end

  defp run_with_opts(opts) do
    previous = Changex.Changelog.read(Keyword.get(opts, :file), Changex.Tag.most_recent())

    Changex.Log.log(nil, Changex.Tag.most_recent())
    |> Changex.Grouper.group_by_type()
    |> Changex.Grouper.group_by_scope()
    |> build(previous, Keyword.get(opts, :format), opts)
    |> write(opts)
  end

  defp write(contents, opts) do
    File.write(Keyword.get(opts, :file), contents)
  end

  defp build(commits, previous, "markdown", opts) do
    head = commits |> Changex.Formatter.Markdown.format(opts)
    head <> "\n\n" <> previous
  end

  defp build(commits, previous, "elixir", opts) do
    head = commits |> Changex.Formatter.Elixir.format(opts)
    head <> "\n\n" <> previous
  end

  defp build(commits, previous, formatter, _opts) do
    head = apply(Module.concat([formatter]), :format, [commits])
    head <> "\n\n" <> previous
  end

  defp add_default_options(opts) do
    Keyword.merge([format: "markdown", file: "CHANGELOG.md"], opts)
  end
end
