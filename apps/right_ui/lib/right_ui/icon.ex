defmodule RightUI.Icon do
  defmacro __using__(_) do
    quote do
      import RightUI.Icon.{
        HeroIcon
      }
    end
  end
end
