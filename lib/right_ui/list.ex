defmodule RightUI.List do
  defmacro __using__(_) do
    quote do
      import RightUI.List.{
        Table
      }
    end
  end
end
