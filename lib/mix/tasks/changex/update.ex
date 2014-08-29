defmodule Mix.Tasks.Changex.Update do
  use Mix.Task

  @shortdoc "Write an update to a file."

  @moduledoc """
  Write an update to the changelog file. Defaults to CHANGELOG.md
  """

  def run(argv) do
    {opts, _, _} = OptionParser.parse(argv)
    opts
    |> add_default_options
    |> run_with_opts
  end

  defp run_with_opts(opts) do
    previous = Changex.Changelog.read(Keyword.get(opts, :file), Changex.Tag.most_recent)
    Changex.Log.log(nil, Changex.Tag.most_recent)
    |> Changex.Grouper.group_by_type
    |> Changex.Grouper.group_by_scope
    |> build(previous, Keyword.get(opts, :format))
    |> write(opts)
  end

  defp write(contents, opts) do
    File.write(Keyword.get(opts, :file), contents)
  end

  defp build(commits, previous, "markdown") do
    head = commits |> Changex.Formatter.Markdown.format
    head <> "\n\n" <> previous
  end

  defp build(commits, previous, "elixir") do
    head = commits |> Changex.Formatter.Elixir.format
    head <> "\n\n" <> previous
  end

  defp build(commits, previous, formatter) do
    head = apply(Module.concat([formatter]), :format, [commits])
    head <> "\n\n" <> previous
  end

  defp add_default_options(opts) do
    Keyword.merge([format: "markdown", file: "CHANGELOG.md"], opts)
  end
end
