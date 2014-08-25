defmodule Changex.ChangelogTest do
  use ExUnit.Case

  test "read gets the contents without the most recent tag" do

    expected = """
    # v0.0.2

    ## Bug Fixes

     * **Mix.Tasks.Changex.Diff**
      * use correct dir for first git ref (f5be945076b7e5f4d8607c43b3c5aaca5697865e)

    # v0.0.1

    ## Features

     * **Changex.Formatter.Terminal**
      * use IO.ANSI.Docs for formatting (98c04f0206789f606d9d7c01baa57b72cc5759cf)
      * output changes to terminal (3026643678a1e94bc90cf7177f9ead3408031f76)
     * **Changex.Grouper**
      * allow commits to be grouped by scope (9c90ce462141cb56aedcf79d17dbe89e03eb3051)
      * add grouper to sort commits by their type (b2a1d8348eeca712126ef5c05c8754e3c2942132)
    """

    assert Changex.Changelog.read("#{__DIR__}/../fixtures/CHANGELOG.md", "v0.0.2") == expected
  end
end
