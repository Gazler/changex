# v0.0.5

## Features

 * **Changex.Formatter.Elixir**
  * pass options list instead of version ([c3919d4f60047cc80af7b3ce7ac87be5826500d4](https://github.com/gazler/changex/commit/c3919d4f60047cc80af7b3ce7ac87be5826500d4))
 * **Changex.Formatter.Markdown**
  * use github url to link to commit hash ([b61b3c16217248787f045cd41bf5e97e479371fa](https://github.com/gazler/changex/commit/b61b3c16217248787f045cd41bf5e97e479371fa))
 * **Changex.Grouper**
  * ignore commits that are not formatted correctly ([01038c82518a479b7c82b8f2139f679a42565a2d](https://github.com/gazler/changex/commit/01038c82518a479b7c82b8f2139f679a42565a2d))
 * **Mix.Tasks.Changex.Diff**
  * pass opts to markdown formatter ([0a5a10d887df2c7b2f6f625e071c4bb03275e404](https://github.com/gazler/changex/commit/0a5a10d887df2c7b2f6f625e071c4bb03275e404))
 * **Mix.Tasks.Changex.Update**
  * pass opts to markdown formatter ([82b6a3b22d15f123bd5987848a4c99cf52bf028b](https://github.com/gazler/changex/commit/82b6a3b22d15f123bd5987848a4c99cf52bf028b))

## Breaking Changes

 * **Changex.Formatter.Elixir**
  * Calling `Changex.Formatter.Elixir.format` with a string
    as the second argument is no longer valid. Instead you can call
    `Changex.Formatter.Elixir.format` with an options list as the second
    argument. This list can contain a `version` key. ([c3919d4f60047cc80af7b3ce7ac87be5826500d4](https://github.com/gazler/changex/commit/c3919d4f60047cc80af7b3ce7ac87be5826500d4))

# v0.0.4

## Features

 * **Changex.Formatter.Elixir**
  * display Breaking Changes (c72a627e49295596fbfedc883277dab72711ed57)
 * **Changex.Formatter.Markdown**
  * display Breaking Changes (8a1b383e352111a629622f7eaf63102aef9e93db)
 * **Changex.Formatter.Terminal**
  * display Breaking Changes (99eeca488a6fa01dc8097d308e164e1b282c4c20)
 * **Changex.Grouper**
  * extract breaking changes from commits (3b9e5180d53a8b1ab3593095e2536df1ac8c4fce)

# v0.0.3

## Bug Fixes

 * **Changex.Formatter.Elixir**
  * remove new lines for empty types (d9574c409e9ad6f5b20038fed196140522f45350)
 * **Changex.Formatter.Markdown**
  * remove new lines for empty types (f9a946590d12812a5b5e286de8f672bc067cfe71)

## Features

 * **Changex.Changelog**
  * allow previous changelog file to be read (aa186d380dd69df6e53fab2c5cf464713e905565)
 * **Changex.Tag**
  * allow most recent git tag to be retrieved (593cafb22b529f9988ec58b263d349a38fd0d4d9)
 * **Mix.Tasks.Changex.Update**
  * allow custom formatter (c5ddfc8342d0b44c91b4dae2a145ffe3adadca35)
  * allow changelog in elixir format (d7adf34c1b1ab2bfa3fdc5a43a0bb8a69ca3a27a)
  * mix task for writing to changelog (8d594d18d4c97a57a1798ca35b72bc38ad78b83f)

# v0.0.2

## Bug Fixes

 * **Mix.Tasks.Changex.Diff**
  * use correct dir for first git ref (f5be945076b7e5f4d8607c43b3c5aaca5697865e)

## Features

 * **Changer.Formatter.Terminal**
  * print version with changelog (9d09b5271060e132296fd98a5f774bdc7093fba3)
 * **Changex.Formatter.Elixir**
  * generate changelog like elixir repo (076e3cff191df131a1500b198860481dcb0b0522)
 * **Changex.Formatter.Markdown**
  * return a string instead of IO.puts (5e8f7c777714c457e21755309d753bfbf86b01ba)
  * allow output in markdown (18b3d3208a42d2ecffaa68f6cf09af4d29c76a49)
 * **Changex.Log**
  * allow a start and end commit to be passed (049a25bd23935e8020a07e64828512cf5413a241)
 * **Mix.Tasks.Changex.Diff**
  * allow a custom formatter via --format (e756eb2c8f811f2a734d1ab23bc211229c4b229a)
  * allow --format option (3db835e48493fb0570ca5363515acf7ab07475c6)
  * allow commit pointers to be passed (28b9cfd89cf8cd2a194e98bc6ee424fffa1a719a)
  * pass a dir through as a --dir argument (8a4b1cc1db9e2ec43d049c843f782d39270356ad)

# v0.0.1

## Features

 * **Changex.Formatter.Terminal**
  * use IO.ANSI.Docs for formatting (98c04f0206789f606d9d7c01baa57b72cc5759cf)
  * output changes to terminal (3026643678a1e94bc90cf7177f9ead3408031f76)
 * **Changex.Grouper**
  * allow commits to be grouped by scope (9c90ce462141cb56aedcf79d17dbe89e03eb3051)
  * add grouper to sort commits by their type (b2a1d8348eeca712126ef5c05c8754e3c2942132)
 * **Changex.Log**
  * add log method to get and format a git log (e40f541763ce53f71addb9ba587de04a22d44a46)
 * **Changex.SubjectSplitter**
  * allow a commit to be split into parts (ce5ec7bd0d1748dbcdbdf5407e1b1b8dc9f3ca76)
 * **Mix.Tasks.Changex.Diff**
  * mix task tooutput changelog to terminal (925dbca076790f00f258a47d34cac050f7a5c447)

