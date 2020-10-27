defmodule Swiss do
  @moduledoc """
  # Swiss

  Swiss is a bundle of extensions to the standard lib. It includes several
  helper functions for dealing with standard types.

  ## API

  The root module has generic helper functions; check each sub-module's docs for
  each type's API.
  """

  @doc """
  Applies the given `func` to `value` and returns its result.

  ### Examples

      iex> Swiss.thru(42, &(12 + &1))
      54
  """
  @spec thru(value :: any(), func :: function()) :: any()
  def thru(value, func), do: func.(value)

  @doc """
  Applies the given `func` to `value` and returns value.

  ### Examples

      iex> Swiss.tap(42, &(12 + &1))
      42
  """
  @spec tap(value :: any(), func :: function()) :: any()
  def tap(value, func) do
    func.(value)
    value
  end

  @doc """
  Applies the given `apply_fn` to the given `value` if the given `predicate_fn`
  returns true.

  By default, `predicate_fn` is `is_present/1`.

  ### Examples

      iex> Swiss.apply_if(42, &(&1 + 8))
      50

      iex> Swiss.apply_if(42, &(&1 + 8), &(&1 > 40))
      50

      iex> Swiss.apply_if(42, &(&1 + 8), &(&1 < 40))
      42
  """
  @spec apply_if(value :: any(), apply_fn :: function(), predicate_fn :: function()) :: any()
  def apply_if(val, apply_fn, predicate_fn \\ &is_present/1) do
    if predicate_fn.(val),
      do: apply_fn.(val),
      else: val
  end

  @doc """
  Applies the given `apply_fn` to the given `value` unless the given
  `predicate_fn` returns true.

  By default, `predicate_fn` is `is_nil/1`.

  ### Examples

      iex> Swiss.apply_unless(nil, &(&1 + 8))
      nil

      iex> Swiss.apply_unless(42, &(&1 + 8))
      50

      iex> Swiss.apply_unless(42, &(&1 + 8), &(&1 > 40))
      42

      iex> Swiss.apply_unless(42, &(&1 + 8), &(&1 < 40))
      50
  """
  def apply_unless(val, apply_fn, predicate_fn \\ &is_nil/1) do
    if predicate_fn.(val),
      do: val,
      else: apply_fn.(val)
  end

  @doc """
  More idiomatic `!is_nil/1`.

  ### Examples

      iex> Swiss.is_present(nil)
      false

      iex> Swiss.is_present([])
      true

      iex> Swiss.is_present(42)
      true
  """
  @spec is_present(val :: any()) :: boolean()
  def is_present(val),
    do: !is_nil(val)

  @doc """
  Wrapper that makes any function usable directly in `Kernel.get_in/2`.

  ### Examples

      iex> get_in([%{"life" => 42}], [Swiss.nextable(&List.first/1), "life"])
      42
  """
  def nextable(fun) do
    fn :get, el, next ->
      next.(fun.(el))
    end
  end
end
