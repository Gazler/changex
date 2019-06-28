defmodule Changex.GrouperTest do
  use ExUnit.Case

  test "group_by_type sorts the commits by their type" do
    commits = [
      ["f329668f8661795f6e2b3c9fd7b7ae6de7dc3789", "fix(baz): set baz", ""],
      ["6a02160216344cf84f8ec7b13bb10a29f2caa340", "chore(bar): set bar", ""],
      ["d01c9ae1622683b1ca33e281ff71d0f10c234c46", "chore(foo): set foo", ""]
    ]

    expected = %{
      fix: [
        [
          hash: "f329668f8661795f6e2b3c9fd7b7ae6de7dc3789",
          type: :fix,
          scope: "baz",
          description: "set baz"
        ]
      ],
      chore: [
        [
          hash: "6a02160216344cf84f8ec7b13bb10a29f2caa340",
          type: :chore,
          scope: "bar",
          description: "set bar"
        ],
        [
          hash: "d01c9ae1622683b1ca33e281ff71d0f10c234c46",
          type: :chore,
          scope: "foo",
          description: "set foo"
        ]
      ]
    }

    assert Changex.Grouper.group_by_type(commits) == expected
  end

  test "group_by_type ignores commits that do not follow the format" do
    commits = [
      ["f329668f8661795f6e2b3c9fd7b7ae6de7dc3789", "fix(baz): set baz", ""],
      ["6a02160216344cf84f8ec7b13bb10a29f2caa340", "IGNORE ME", ""],
      ["d01c9ae1622683b1ca33e281ff71d0f10c234c46", "chore(foo): set foo", ""]
    ]

    expected = %{
      fix: [
        [
          hash: "f329668f8661795f6e2b3c9fd7b7ae6de7dc3789",
          type: :fix,
          scope: "baz",
          description: "set baz"
        ]
      ],
      chore: [
        [
          hash: "d01c9ae1622683b1ca33e281ff71d0f10c234c46",
          type: :chore,
          scope: "foo",
          description: "set foo"
        ]
      ]
    }

    assert Changex.Grouper.group_by_type(commits) == expected
  end

  test "group_by_type includes breaking changes" do
    commits = [
      [
        "f329668f8661795f6e2b3c9fd7b7ae6de7dc3789",
        "fix(baz): set baz",
        "some stuff",
        "BREAKING CHANGE: this breaks",
        "a previous thing",
        "",
        "BREAKING CHANGE: another",
        ""
      ],
      ["6a02160216344cf84f8ec7b13bb10a29f2caa340", "chore(bar): set bar", ""],
      [
        "d01c9ae1622683b1ca33e281ff71d0f10c234c46",
        "chore(foo): set foo",
        "BREAKING CHANGE: this also breaks",
        "something",
        ""
      ]
    ]

    expected = %{
      fix: [
        [
          hash: "f329668f8661795f6e2b3c9fd7b7ae6de7dc3789",
          type: :fix,
          scope: "baz",
          description: "set baz"
        ]
      ],
      chore: [
        [
          hash: "6a02160216344cf84f8ec7b13bb10a29f2caa340",
          type: :chore,
          scope: "bar",
          description: "set bar"
        ],
        [
          hash: "d01c9ae1622683b1ca33e281ff71d0f10c234c46",
          type: :chore,
          scope: "foo",
          description: "set foo"
        ]
      ],
      break: [
        [
          hash: "f329668f8661795f6e2b3c9fd7b7ae6de7dc3789",
          type: :break,
          scope: "baz",
          description: "this breaks\na previous thing"
        ],
        [
          hash: "f329668f8661795f6e2b3c9fd7b7ae6de7dc3789",
          type: :break,
          scope: "baz",
          description: "another"
        ],
        [
          hash: "d01c9ae1622683b1ca33e281ff71d0f10c234c46",
          type: :break,
          scope: "foo",
          description: "this also breaks\nsomething"
        ]
      ]
    }

    assert Changex.Grouper.group_by_type(commits) == expected
  end

  test "group_by_scope sorts the commits by their scope" do
    commits = %{
      fix: [
        [
          hash: "f329668f8661795f6e2b3c9fd7b7ae6de7dc3789",
          type: :fix,
          scope: "baz",
          description: "set baz"
        ]
      ],
      chore: [
        [
          hash: "6a02160216344cf84f8ec7b13bb10a29f2caa340",
          type: :chore,
          scope: "foo",
          description: "set foo"
        ],
        [
          hash: "d01c9ae1622683b1ca33e281ff71d0f10c234c46",
          type: :chore,
          scope: "foo",
          description: "set foo"
        ]
      ]
    }

    expected = %{
      fix: %{
        "baz" => [
          [
            hash: "f329668f8661795f6e2b3c9fd7b7ae6de7dc3789",
            type: :fix,
            scope: "baz",
            description: "set baz"
          ]
        ]
      },
      chore: %{
        "foo" => [
          [
            hash: "6a02160216344cf84f8ec7b13bb10a29f2caa340",
            type: :chore,
            scope: "foo",
            description: "set foo"
          ],
          [
            hash: "d01c9ae1622683b1ca33e281ff71d0f10c234c46",
            type: :chore,
            scope: "foo",
            description: "set foo"
          ]
        ]
      }
    }

    assert Changex.Grouper.group_by_scope(commits) == expected
  end
end
