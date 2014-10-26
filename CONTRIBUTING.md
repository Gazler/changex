#Contributing to Changex

Thanks for deciding to contribute to Changex.

## Submittion Guidelines

## Submitting an issue

Please search the [repository issues](https://github.com/Gazler/changex/issues) to see if someone else has had a similar issue before raising a new issue.

### Submitting a Pull Request

#### Commit Messages

All pull request commit messages are automatically checked using [GitCop](http://gitcop.com) - this will inform you if there are any issues with your commit message and give you an oppertunity to change it.

##### Length

No line in your commit message shoult be longer than **72** characters. If you have something that is longer than this (such as a url), please put it on to multiple lines with a backspace at the end of each line.

##### Format

Because Changex automatically generates the [CHANGELOG.md](https://github.com/Gazler/changex/blob/master/CHANGELOG.md) from the commit messages, it is important that the follow these rules.

Please ensure that your commit messages follow the following format:

    %{type}(%{scope}): %{description}

Where type is one of the following:

 * **feat** - A feature
 * **fix** - A bug fix or fixes to broken tests
 * **docs** - Documentation changes
 * **style** - Code changes such as whitespace or bracket position
 * **refactor** - Code changes that do not fit in the above
 * **perf** - Code changes that improve performance
 * **test** - Adding missing tests
 * **revert** - Reverting the code changes in a previous commit
 * **chore** - Changes that do not fit elsewhere

Breaking changes should be added at the bottom of the commit message in the following format:

    BREAKING CHANGE: description

An example commit for this can be seen at https://github.com/Gazler/changex/commit/c3919d4f60047cc80af7b3ce7ac87be5826500d4
