defmodule RightUI.Navigation do
  defmacro __using__(_) do
    quote do
      import RightUI.Navigation.{
        Pagination
      }
    end
  end
end
