defmodule Changex.Formatter do
  @moduledoc """
  A module containing functions to be used inside other formatters.
  """

  defmodule Utils do
    @doc """
    Return the version from the project based on the config specified in
    the `mix.exs` file. To ensure consistency with git tags this is
    prefixed with the letter "v".
    """
    def current_version do
      "v#{Keyword.get(Mix.Project.config, :version)}"
    end
  end

  @doc false
  defmacro __using__(_opts) do
    quote do
      import Utils
    end
  end
end
