defmodule RightUI.Icon.HeroIcon do
  use RightUI, :component

  defmacro __using__(_) do
    quote do
      import RightUI.Icon.HeroIcon, only: [heroicon: 1]
    end
  end

  @library Adept.Svg.compile("priv/icons/node_modules/heroicons")

  def heroicon(assigns) do
    assigns =
      assigns
      |> attr(:name, :string, required: true)
      |> attr(:enable_default_size, :boolean, default: true)
      |> attr(:class, :string)
      |> attr(:extra, :rest)
      |> attr_done()

    ~H"""
    <%= render_svg(
      @name,
      [
        class:
          if(@enable_default_size,
            do: merge_class([class_size_for(@name), @class]),
            else: @class
          )
      ] ++ @extra
    ) %>
    """
  end

  defp library(), do: @library

  defp render_svg(key, opts) do
    Adept.Svg.render(library(), key, opts)
  end

  defp class_size_for("outline/" <> _), do: "w-6 h-6"
  defp class_size_for("solid/" <> _), do: "w-5 h-5"
  defp class_size_for(_), do: ""
end
