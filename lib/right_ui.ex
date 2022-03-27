defmodule RightUI do
  @moduledoc """
  Documentation for `RightUI`.
  """

  def component do
    quote do
      use Phoenix.Component

      unquote(view_helpers())
    end
  end

  def live_component do
    quote do
      use Phoenix.LiveComponent

      unquote(view_helpers())
    end
  end

  defp view_helpers do
    quote do
      import RightUI.Helper
    end
  end

  @doc false
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end

  defmacro __using__(_) do
    quote do
      use RightUI.Element
      use RightUI.Icon

      use RightUI.Layout
      use RightUI.List
      use RightUI.Navigation
    end
  end
end
