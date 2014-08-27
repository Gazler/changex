# 0.0.3-dev

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

