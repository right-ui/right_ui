defmodule RightUI.Layout do
  defmacro __using__(_) do
    quote do
      use RightUI.Layout.{
        Container
      }
    end
  end
end
