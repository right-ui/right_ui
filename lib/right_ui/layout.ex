defmodule RightUI.Layout do
  defmacro __using__(_) do
    quote do
      import RightUI.Layout.{
        Container
      }
    end
  end
end
