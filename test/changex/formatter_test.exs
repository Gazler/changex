defmodule Changex.FormatterTest do
  use ExUnit.Case
  use Changex.Formatter

  test "current_version gets the current version from mix.exs" do

    expected_version = Keyword.get(Mix.Project.config, :version)
    assert current_version == "v#{expected_version}"
  end
end
