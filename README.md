# Swiss

[![Module Version](https://img.shields.io/hexpm/v/swiss.svg)](https://hex.pm/packages/swiss)
[![Hex Docs](https://img.shields.io/badge/hex-docs-lightgreen.svg)](https://hexdocs.pm/swiss/)
[![Total Download](https://img.shields.io/hexpm/dt/swiss.svg)](https://hex.pm/packages/swiss)
[![License](https://img.shields.io/hexpm/l/swiss.svg)](https://github.com/myskoach/swiss/blob/master/LICENSE)
[![Last Updated](https://img.shields.io/github/last-commit/myskoach/swiss.svg)](https://github.com/yyy/swiss/commits/master)

Swiss is a bundle of extensions to the standard lib. It includes several helper
functions for dealing with standard types.

Check out the [API Reference](https://hexdocs.pm/swiss/api-reference.html) for the full module list & examples.

### Examples

    iex> Swiss.String.kebab_case("PatatSpecial")
    "patat-special"

    iex> Swiss.Enum.find_by([%{key: 1}, %{key: 2}], :key, 1)
    %{key: 1}

## Installation

Add `:swiss` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:swiss, "~> 3.6.0"}
  ]
end
```

## Contributing

PRs welcome, unit tests required.

## Copyright and License

Copyright (c) 2019 João Ferreira

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at [http://www.apache.org/licenses/LICENSE-2.0](http://www.apache.org/licenses/LICENSE-2.0)

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
