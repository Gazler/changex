defmodule Changex.Formatter.ElixirTest do
  use ExUnit.Case

  setup do
    commits = %{
      feat: %{
        "dashboard" => [
          [
            hash: "5c764b2957d1c6e7ed73e1691a55399c85b62c34",
            type: :feat,
            scope: "dashboard",
            description: "show number of bots on the dashboard"
          ]
        ]
      },
      fix: %{
        "policy" => [
          [
            hash: "1d98f2f0997a0039933dd16ff5668a94f9b29c3f",
            type: :fix,
            scope: "policy",
            description: "remove reference to data retention length"
          ]
        ],
        "user" => [
          [
            hash: "02dec817f05f951ebd01c4408e3e3bbfa1f46636",
            type: :fix,
            scope: "user",
            description: "ensure associations are destroyed on deletion"
          ]
        ]
      },
      break: %{
        "policy" => [
          [
            hash: "1d98f2f0997a0039933dd16ff5668a94f9b29c3f",
            type: :break,
            scope: "policy",
            description: "a breaking change\nit breaks"
          ],
          [
            hash: "1d98f2f0997a0039933dd16ff5668a94f9b29c3f",
            type: :break,
            scope: "policy",
            description: "Another breaking change"
          ]
        ]
      }
    }

    {:ok, [commits: commits]}
  end

  test "Formatting with an explicit version", %{commits: commits} do
    assert Changex.Formatter.Elixir.format(commits, version: "v10") == expected_markdown("v10")
  end

  test "Formatting with an implicit version", %{commits: commits} do
    version = Keyword.get(Mix.Project.config(), :version)
    assert Changex.Formatter.Elixir.format(commits) == expected_markdown("v#{version}")
  end

  test "Formatting with a missing type" do
    commits = %{
      fix: %{
        "policy" => [
          [
            hash: "1d98f2f0997a0039933dd16ff5668a94f9b29c3f",
            type: :fix,
            scope: "policy",
            description: "remove reference to data retention length"
          ]
        ]
      }
    }

    expected =
      """
      ## v10

      * Bug fixes
        * [policy] remove reference to data retention length
      """
      |> String.trim_trailing()

    assert Changex.Formatter.Elixir.format(commits, version: "v10") == expected
  end

  defp expected_markdown(version) do
    """
    ## #{version}

    * Enhancements
      * [dashboard] show number of bots on the dashboard
    * Bug fixes
      * [policy] remove reference to data retention length
      * [user] ensure associations are destroyed on deletion
    * Breaking changes
      * [policy] a breaking change
        it breaks
      * [policy] Another breaking change
    """
    |> String.trim_trailing()
  end
end
