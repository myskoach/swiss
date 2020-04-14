defmodule Swiss.Enum.KeyValueError do
  defexception [:key, :value, :term, :message]

  @impl true
  def message(%{message: nil} = error) do
    message(error.key, error.value, error.term)
  end

  def message(%{message: message}),
    do: message

  def message(key, value, term) do
    "key #{inspect(key)} with value #{inspect(value)} not found in: #{inspect(term)}"
  end
end
