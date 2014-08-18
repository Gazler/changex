defmodule Changex.LogTest do
  use ExUnit.Case

  @dir "/tmp/changex_test"

  setup_all do
    File.mkdir_p(@dir)
    File.cd(@dir)
    System.cmd("git", ["init"])
    commit_file("foo")
    commit_file("bar")
    commit_file("baz", "fix")
    on_exit fn() -> File.rm_rf(@dir) end
    :ok
  end

  test "log produces a list of [hash, subject | body]" do
    hashes = get_hashes
    expected = [
      [Enum.at(hashes, 0), "fix(baz): set baz", ""],
      [Enum.at(hashes, 1), "chore(bar): set bar", ""],
      [Enum.at(hashes, 2), "chore(foo): set foo", ""]
    ]
    assert Changex.Log.log == expected
  end

  defp get_hashes do
    {hashes, 0} = System.cmd("git", ["--git-dir=#{@dir}/.git", "log", "--pretty=format:%H"])
    hashes |> String.split("\n")
  end

  defp commit_file(filename, type \\ "chore") do
    File.touch(filename)
    System.cmd("git", ["add", filename])
    System.cmd("git", ["commit", "-m", "#{type}(#{filename}): set #{filename}"])
  end
end
