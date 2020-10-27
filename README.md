# Swiss

Swiss is a bundle of extensions to the standard lib. It includes several helper
functions for dealing with standard types.

### Examples

    iex> Swiss.String.kebab_case("PatatSpecial")
    "patat-special"

    iex> Swiss.DateTime.second_utc_now()
    ?

## API

The root module has no functions; check each sub-module's docs for each type's
API.
"""

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `swiss` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:swiss, "~> 2.14.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/swiss](https://hexdocs.pm/swiss).

