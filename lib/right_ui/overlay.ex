defmodule RightUI.Overlay do
  defmacro __using__(_) do
    quote do
      import RightUI.Overlay.{
        Modal
      }
    end
  end
end
