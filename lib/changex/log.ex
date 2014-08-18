defmodule Changex.Log do
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
