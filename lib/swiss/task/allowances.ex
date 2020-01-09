defmodule Swiss.Task.Allowances do
  @callback allow(parent :: pid()) :: no_return()
end
