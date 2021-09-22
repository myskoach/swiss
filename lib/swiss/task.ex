defmodule Swiss.Task do
  @moduledoc """
  Functions for writing async code that's testable asynchronously by passing
  allowances to created processes. You should import this module and use its
  macros as a DSL.

  ### Examples

      defmodule YourProject.Task do
        @moduledoc "Defines the Task API for your project"

        import Swiss.Task
        async YourProject.Task.Allowances
        async_stream YourProject.Task.Allowances
      end

      defmodule YourProject.Task.Allowances do
        @moduledoc "Defines the Allowances behaviour"

        @behaviour Swiss.Task.Allowances

        @impl true
        def allow(parent) do
          Ecto.Adapters.SQL.Sandbox.allow(YourProject.Repo, parent, self())
        end
      end

      defmodule YourProject.SomeModule do
        def some_async_function do
          YourProject.Task.async(fn -> end)
        end

        def some_other_async_function(enumerable) do
          YourProject.Task.async_stream(enumerable, fn -> end)
        end
      end

  """

  @doc """
  Call this macro from your projects `Task` module to declare an `async`
  function that, in a test environment, runs the called module's `allow`
  function with the parent process's PID.

  In other envs this delegates to the `Elixir.Task.async/1` function.
  """
  defmacro async(allowances_module) do
    allowances_module = Macro.expand(allowances_module, __CALLER__)
    env = Mix.env()

    case env do
      :test ->
        quote do
          def async(fun) do
            parent = self()
            Task.async(fn ->
              unquote(allowances_module).allow(parent)
              fun.()
            end)
          end
        end
      _ ->
        quote do
          defdelegate async(fun), to: Task
        end
    end
  end

  @doc """
  Call this macro from your project's `Task` module to define an `async_stream`
  function that, in a test environment, runs the called module's `allow`
  function with the parent process's PID

  In other envs this delegates to the `Elixir.Task.async_stream/3` function.
  """
  defmacro async_stream(allowances_module) do
    allowances_module = Macro.expand(allowances_module, __CALLER__)
    env = Mix.env()

    case env do
      :test ->
        quote do
          def async_stream(enumerable, fun, opts \\ []) do
            parent = self()
            Task.async_stream(enumerable, fn arg ->
              unquote(allowances_module).allow(parent)
              fun.(arg)
            end, opts)
          end
        end
      _ ->
        quote do
          defdelegate async_stream(enumerable, fun), to: Task
          defdelegate async_stream(enumerable, fun, opts), to: Task
        end
    end
  end
end
