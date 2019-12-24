defmodule Swiss.Task do
  @moduledoc """
  Functions for writing async code that's testable asynchronously. You should
  import this module and use its macros as a DSL.

  Right now it only makes sense to use this module if you're using Ecto's
  Sandbox adapter.

  ### Example
      defmodule YourProject.Task do
        import Swiss.Task
        async YourProject.Repo
      end

      defmodule YourProject.SomeModule do
        def some_async_function do
          YourProject.Task.async(fn -> end)
        end
      end
  """

  @env Mix.env()


  @doc """
  Call this macro from your projects `Task` module to declare an `async`
  function that, in a test environment, allows the async process to use the
  caller's Ecto connection.

  In other envs this delegates to the `Elixir.Task/1` function.
  """
  defmacro async(repo) do
    repo = Macro.expand(repo, __CALLER__)

    case @env do
      :test ->
        quote do
          def async(fun) do
            parent = self()
            Task.async(fn ->
              Ecto.Adapters.SQL.Sandbox.allow(unquote(repo), parent, self())
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
end
