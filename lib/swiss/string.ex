defmodule Swiss.String do
  @moduledoc """
  A few extra functions to deal with Strings. Heavily inspired by lodash.
  """

  @word_regex ~r/[^\x00-\x2f\x3a-\x40\x5b-\x60\x7b-\x7f]+/
  @upper_word_regex ~r/(^[A-Z]+$)|[A-Z][a-z0-9]*/

  @doc """
  Deburrs a string from unicode to its ascii equivalent.

  ## Examples

      iex> Swiss.String.deburr "hola señor!"
      "hola senor!"

  """
  @spec deburr(String.t()) :: String.t()
  def deburr(string) do
    string
    |> :unicode.characters_to_nfd_binary()
    |> String.replace(~r/[^\x00-\x7F]/u, "")
  end

  @doc """
  Decomposes a string into an array of its words.

  ## Examples

      iex> Swiss.String.words "FredBarney"
      ["Fred", "Barney"]

      iex> Swiss.String.words "fred, barney, & pebbles"
      ["fred", "barney", "pebbles"]

      iex> Swiss.String.words "fred, barney, & pebbles", ~r/[^, ]+/
      ["fred", "barney", "&", "pebbles"]

  """
  @spec words(String.t(), Regex.t()) :: [String.t()]
  def words(string, pattern \\ @word_regex) do
    string
    |> String.split(pattern, trim: true, include_captures: true)
    |> Enum.filter(&String.match?(&1, pattern))
    |> Enum.flat_map(&String.split(&1, @upper_word_regex, trim: true, include_captures: true))
  end

  @doc """
  Converts a string into kebab-case.

  ## Examples

      iex> Swiss.String.kebab_case "Foo Bar"
      "foo-bar"

      iex> Swiss.String.kebab_case "--foo-bar--"
      "foo-bar"

      iex> Swiss.String.kebab_case "__FOO_BAR__"
      "foo-bar"

      iex> Swiss.String.kebab_case "FooBar"
      "foo-bar"

  """
  @spec kebab_case(String.t()) :: String.t()
  def kebab_case(string) do
    string
    |> deburr()
    |> words()
    |> Stream.map(&String.downcase/1)
    |> Enum.join("-")
  end

  @doc """
  Converts a string into snake_case.

  ## Examples

      iex> Swiss.String.snake_case "Foo Bar"
      "foo_bar"

      iex> Swiss.String.snake_case "--foo-bar--"
      "foo_bar"

      iex> Swiss.String.snake_case "__FOO_BAR__"
      "foo_bar"

      iex> Swiss.String.snake_case "FooBar"
      "foo_bar"

  """
  @spec snake_case(String.t()) :: String.t()
  def snake_case(string) do
    string
    |> deburr()
    |> words()
    |> Stream.map(&String.downcase/1)
    |> Enum.join("_")
  end

  @doc """
  Converts a string to Capital Case.

  ## Options

    * `:deburr`: whether to deburr (remove accents, etc.) the given string.
      `true` by default, for consistency with the other functions in this module.

  ## Examples

      iex> Swiss.String.start_case "Foo Bar"
      "Foo Bar"

      iex> Swiss.String.start_case "--foo-bar--"
      "Foo Bar"

      iex> Swiss.String.start_case "__FOO_BAR__"
      "Foo Bar"

      iex> Swiss.String.start_case "FooBar"
      "Foo Bar"

      iex> Swiss.String.start_case "hola señor"
      "Hola Senor"

      iex> Swiss.String.start_case "hola señor", deburr: false
      "Hola Señor"

  """
  @spec start_case(String.t(), keyword()) :: String.t()
  def start_case(string, opts \\ []) do
    string
    |> Swiss.apply_if(&deburr/1, Keyword.get(opts, :deburr, true))
    |> words()
    |> Stream.map(&String.capitalize/1)
    |> Enum.join(" ")
  end

  @doc """
  Inserts a substring into another string at the given position.

  ## Examples

      iex> Swiss.String.insert_at "Banas", 2, "na"
      "Bananas"

      iex> Swiss.String.insert_at "800", -2, "."
      "8.00"

  """
  @spec insert_at(String.t(), integer(), String.t()) :: String.t()
  def insert_at(string, pos, substr) do
    {left, right} = String.split_at(string, pos)
    left <> substr <> right
  end
end
