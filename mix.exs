defmodule Changex.Mixfile do
  use Mix.Project

  def project do
    [
      app: :changex,
      version: "0.2.0",
      elixir: "~> 1.0",
      description: description(),
      package: package(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [applications: [:logger]]
  end

  defp description do
    """
    Automatically generate a CHANGELOG.md file based on git commit
    history.
    """
  end

  defp package do
    # These are the default files included in the package
    [
      files: [
        "lib",
        "priv",
        "mix.exs",
        "README*",
        "readme*",
        "LICENSE*",
        "license*",
        "CHANGELOG*"
      ],
      contributors: ["Gary 'Gazler' Rennie"],
      licenses: ["MIT Licence"],
      links: %{
        "GitHub" => "https://github.com/Gazler/changex",
        "Docs" => "http://hexdocs.pm/changex"
      }
    ]
  end

  # Dependencies can be hex.pm packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1"}
  #
  # Type `mix help deps` for more examples and options
  defp deps do
    []
  end
end
