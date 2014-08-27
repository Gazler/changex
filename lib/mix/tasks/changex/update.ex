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
    write(opts, Keyword.get(opts, :format))
  end

  defp write(opts, "markdown") do
    head = Changex.Log.log(nil, Changex.Tag.most_recent)
    |> Changex.Grouper.group_by_type
    |> Changex.Grouper.group_by_scope
    |> Changex.Formatter.Markdown.format
    previous = Changex.Changelog.read(Keyword.get(opts, :file), Changex.Tag.most_recent)
    File.write(Keyword.get(opts, :file), head <> "\n\n" <> previous)
  end

  defp add_default_options(opts) do
    Keyword.merge([format: "markdown", file: "CHANGELOG.md"], opts)
  end
end
