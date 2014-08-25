defmodule Changex.TagTest do
  use ExUnit.Case

  @dir "/tmp/changex_test"

  setup_all do
    File.mkdir_p(@dir)
    File.cd(@dir)
    System.cmd("git", ["init"])
    commit_file("init")
    commit_file("foo")
    git_tag("v0.1.0-dev")
    on_exit fn() -> File.rm_rf(@dir) end
    :ok
  end

  test "most_recent outputs the most recent tag" do
    File.cd(@dir)
    assert Changex.Tag.most_recent == "v0.1.0-dev"
  end

  test "log can take an explicit directory" do
    File.cd("/tmp")
    assert Changex.Tag.most_recent("/tmp/changex_test/") == "v0.1.0-dev"
  end

  defp commit_file(filename, type \\ "chore") do
    File.touch(filename)
    System.cmd("git", ["add", filename])
    System.cmd("git", ["commit", "-m", "#{type}(#{filename}): set #{filename}"])
  end

  defp git_tag(tag) do
    System.cmd("git", ["tag", tag])
  end
end
