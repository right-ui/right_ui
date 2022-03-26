defmodule RightUI.Element do
  defmacro __using__(_) do
    quote do
      import RightUI.Element.{
        Button,
        Link
      }
    end
  end
end
