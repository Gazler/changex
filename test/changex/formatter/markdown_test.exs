defmodule Changex.Formatter.MarkdownTest do
  use ExUnit.Case

  setup do
    commits = %{feat: %{"dashboard" => [[hash: "5c764b2957d1c6e7ed73e1691a55399c85b62c34",
          type: :feat, scope: "dashboard",
          description: "show number of bots on the dashboard"]]},
      fix: %{"policy" => [[hash: "1d98f2f0997a0039933dd16ff5668a94f9b29c3f",
          type: :fix, scope: "policy",
          description: "remove reference to data retention length"]],
        "user" => [[hash: "02dec817f05f951ebd01c4408e3e3bbfa1f46636", type: :fix,
          scope: "user",
          description: "ensure associations are destroyed on deletion"]]}}
    {:ok, [commits: commits]}
  end

  test "Formatting with an explicit version", %{commits: commits} do
    assert Changex.Formatter.Markdown.format(commits, "v10") == expected_markdown("v10")
  end

  test "Formatting with an implicit version", %{commits: commits} do
    version = Keyword.get(Mix.Project.config, :version)
    assert Changex.Formatter.Markdown.format(commits) == expected_markdown(version)
  end

  defp expected_markdown(version) do
    """
    # #{version}

    ## Bug Fixes

     * **policy**
      * remove reference to data retention length (1d98f2f0997a0039933dd16ff5668a94f9b29c3f)
     * **user**
      * ensure associations are destroyed on deletion (02dec817f05f951ebd01c4408e3e3bbfa1f46636)
    
    ## Features
    
     * **dashboard**
      * show number of bots on the dashboard (5c764b2957d1c6e7ed73e1691a55399c85b62c34)
    """

  end
end
