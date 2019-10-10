defmodule Swiss do
  @moduledoc """
  # Swiss

  Swiss is a bundle of extensions to the standard lib. It includes several
  helper functions for dealing with standard types.

  ### Examples

      iex> Swiss.String.kebab_case("Patat Special")
      "patat-special"

      iex> Swiss.DateTime.second_utc_now()
      #DateTime<2019-10-10 10:20:46Z>

  ## API

  The root module has no functions; check each sub-module's docs for each type's
  API.
  """
end
