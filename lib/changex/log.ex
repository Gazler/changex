defmodule Changex.Log do
  @moduledoc """
  This module will get a list of commits based on the git log on a git
  repository.
  """

  @doc """
  Output a log in the format:

      [
        ["f329668f8661795f6e2b3c9fd7b7ae6de7dc3789", "fix(baz): set baz"],
        ["6a02160216344cf84f8ec7b13bb10a29f2caa340", "chore(bar): set bar"],
      ]

  An optional `dir` argument can be passed in, if present then this
  location will be used for the git repository instead of the current
  directory.
  """
  def log(dir \\ nil) do
    args = ["log", "--pretty=format:%H%n%s%n%b==END==", "--no-merges"]
    if dir != nil do
      args = ["--git-dir=#{dir}.git" | args]
    end
    {output, _exit_code = 0} = System.cmd("git", args)
    output
    |> String.split("==END==")
    |> Enum.map(fn str -> String.lstrip(str) |> String.split("\n") end)
    |> Enum.filter(fn commit -> commit != [""] end)
  end
end
