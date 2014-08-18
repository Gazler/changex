defmodule Changex.SubjectSplitter do

  @moduledoc """
  This module is used to split the subject of a commit message based on
  a format passed in.
  """

  @doc """
  Split the `subject` based on the `format`.

  ## Examples

      iex> subject = "fix(user): ensure email is required"
      iex> format = "%{type}(%{scope}): %{description}"
      iex> Changex.SubjectSplitter.get_parts(subject, format)
      [type: "fix", scope: "user", description: "ensure email is required"]
  """
  def get_parts(subject, format) do
    Regex.split(~r/(?<head>)%{[^}]+}(?<tail>)/, format, trim: true, on: [:head, :tail])
    |> parse_parts(subject)
  end

  defp parse_parts(parts, message) do
    parse_part(parts, message)
  end

  defp parse_part([part | []], message) do
    if matches = Regex.run(~r/%\{(.+)\}/, part) do
      [_, part_name] = matches
      add_part(part_name, message)
    end
  end
  defp parse_part([part, next | parts], message) do
    rest = [next | parts]
    if matches = Regex.run(~r/%\{(.+)\}/, part) do
      [_, part_name] = matches
      {key, new_message} = String.split(message, next, parts: 2) |> rest_of_message
      [{String.to_atom(part_name), key} | parse_part(rest, new_message)]
    else
      parse_part(rest, message)
    end
  end

  defp add_part(part_name, ""), do: [{String.to_atom(part_name), nil}]
  defp add_part(part_name, message), do: [{String.to_atom(part_name), message}]

  defp rest_of_message([key, message]) do
    {key, message}
  end

  defp rest_of_message(_) do
    {nil, ""}
  end
end
