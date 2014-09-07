# Changex

Mix tasks for parsing git log.

## Usage

Add Changex as a dependency in your `mix.exs` file.

```elixir
def deps do
  [ { :changex } ]
end
```

After you are done, run `mix deps.get` to fetch and compile Changex. You will now have access to the changex mix tasks in your project.

## Mix Tasks

### Changex.Diff

If you run `mix changex.diff` then a diff based on your git commit history will be generated. This can be called in several way:


To generate a changelog from the most recent tag (the root commit will be used if there are no tags) to the git HEAD run:

```elixir
mix changex.diff
```

To generate a changelog from a git reference (commit, tag, etc.) to HEAD run:

```elixir
mix changex.diff a87a32f
mix changex.diff v0.1.0
mix changex.diff HEAD~5
```

To generate a changelog between two commit references:

```elixir
mix changex.diff a87a32f v0.1.0
mix changex.diff v0.1.0 v0.1.1
mix changex.diff HEAD~5 HEAD~2
```

The following options are also available:

    Option          Description
    ----------      ------
    --dir           Run changex.diff using a directory other than the current one
    --format        Change the output format. One of terminal, markdown or elixir

### Changex.Update

If you run `mix changex.update` then the changelog file in the repository will be updated. This will use the most recent tag if available, if not then it will use the root node of the repository.


To write to the file CHANGELOG.md run:

```elixir
mix changex.update
```

The following options are also available:

    Option          Description
    ----------      ------
    --file          Change the file for the output to be written to. Defaults to CHANGELOG.md
    --format        Change the output format. One of markdown or elixir, defaults to markdown
