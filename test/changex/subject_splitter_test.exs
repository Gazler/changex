defmodule Changex.SubjectSplitterTest do
  use ExUnit.Case

  test "getting the parts of a message" do
    subject = "fix(user): ensure email is required"
    format = "%{type}(%{scope}): %{description}"
    assert(Changex.SubjectSplitter.get_parts(subject, format) == [type: "fix", scope: "user", description: "ensure email is required"])
  end

  test "getting the parts of an invalid message" do
    subject = "fix(user) ensure email is required"
    format = "%{type}(%{scope}): %{description}"
    assert(Changex.SubjectSplitter.get_parts(subject, format) == [type: "fix", scope: nil, description: nil])
  end
end

