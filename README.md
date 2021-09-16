# Swiss

Swiss is a bundle of extensions to the standard lib. It includes several helper
functions for dealing with standard types.

Check out the [API Reference](https://hexdocs.pm/swiss/api-reference.html) for the full module list & examples.

### Examples

    iex> Swiss.String.kebab_case("PatatSpecial")
    "patat-special"

    iex> Swiss.Enum.find_by([%{key: 1}, %{key: 2}], :key, 1)
    %{key: 1}

## Installation

Add `swiss` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:swiss, "~> 3.5.0"}
  ]
end
```

## Contributing

PRs welcome, unit tests required.
