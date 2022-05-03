defmodule RightUI do
  @moduledoc """
  Documentation for `RightUI`.
  """

  def component do
    quote do
      use Phoenix.Component
      alias Phoenix.LiveView.JS

      unquote(view_helpers())
    end
  end

  def live_component do
    quote do
      use Phoenix.LiveComponent
      alias Phoenix.LiveView.JS

      unquote(view_helpers())
    end
  end

  defp view_helpers do
    quote do
      import RightUI.Helper
      import RightUI.Sigil
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
      use RightUI.Overlay
    end
  end
end
