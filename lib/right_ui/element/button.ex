defmodule RightUI.Element.Button do
  use RightUI, :component

  defmacro __using__(_) do
    quote do
      import RightUI.Button, only: [button: 1]
    end
  end

  def button(assigns) do
    assigns =
      assigns
      |> attr(:type, :enum, values: ["button", "a", "live_patch", "live_redirect"], default: "a")
      |> attr(:size, :enum, values: ["xs", "sm", "md", "lg", "xl"], default: "md")
      |> attr(:color, :enum,
        values: ["primary", "neutral", "info", "success", "warning", "danger"],
        default: "primary"
      )
      |> attr(:variant, :enum, values: ["normal", "outline", "monochrome"], default: "normal")
      |> attr(:class, :string)
      |> attr(:inner_block, :slot, required: true)
      |> attr(:extra, :rest)
      |> attr_done()

    ~H"""
    <%= apply(button_function(@type), [
      [
        class:
          merge_class([
            class_display(),
            class_transition(),
            class_padding(@size),
            class_text(@size),
            class_border(@size),
            class_hover(@size),
            class_focus(@size),
            class_color(@color, @variant),
            @class
          ])
      ] ++ @extra,
      [do: render_slot(@inner_block)]
    ]) %>
    """
  end

  defp button_function("button"), do: &Phoenix.HTML.Link.button/2
  defp button_function("a"), do: &Phoenix.HTML.Link.link/2
  defp button_function("live_patch"), do: &live_patch/2
  defp button_function("live_redirect"), do: &live_redirect/2

  defp class_display(), do: "flex justify-center items-center"

  defp class_transition(), do: "transition ease-in-out duration-300"

  defp class_padding("xs"), do: "px-2.5 py-1.5"
  defp class_padding("sm"), do: "px-3 py-2"
  defp class_padding("md"), do: "px-4 py-2"
  defp class_padding("lg"), do: "px-4 py-2"
  defp class_padding("xl"), do: "px-6 py-3"

  defp class_text("xs"), do: "font-medium text-sm leading-4"
  defp class_text("sm"), do: "font-medium text-sm"
  defp class_text("md"), do: "font-medium text-sm"
  defp class_text("lg"), do: "font-medium text-base"
  defp class_text("xl"), do: "font-medium text-base"

  defp class_border("xs"), do: "border border-transparent rounded shadow-sm"
  defp class_border("sm"), do: "border border-transparent rounded-md shadow-sm"
  defp class_border("md"), do: "border border-transparent rounded-md shadow-sm"
  defp class_border("lg"), do: "border border-transparent rounded-md shadow-sm"
  defp class_border("xl"), do: "border border-transparent rounded-md shadow-sm"

  defp class_hover(_), do: ""

  defp class_focus(_), do: "outline-none focus:outline-none focus:ring focus:ring-offset-0"

  defp class_color("primary", variant) do
    case variant do
      "outline" ->
        """
        text-primary-600 bg-white border-primary-600
        hover:text-white hover:bg-primary-600
        active:bg-primary-700 active:border-primary-700
        focus:ring-primary-500/30
        """

      "monochrome" ->
        """
        text-neutral-700 bg-white border-neutral-300
        hover:bg-neutral-50
        active:bg-neutral-100
        focus:border-primary-400 focus:ring-primary-500/30
        """

      _ ->
        """
        text-white bg-primary-700
        hover:bg-primary-600
        active:bg-primary-700
        focus:ring-primary-500/30
        """
    end
  end

  defp class_color("neutral", variant) do
    case variant do
      "outline" ->
        """
        text-neutral-600 bg-white border-neutral-600
        hover:text-white hover:bg-neutral-600
        active:bg-neutral-700 active:border-neutral-700
        focus:ring-neutral-500/30
        """

      "monochrome" ->
        """
        text-neutral-700 bg-white border-neutral-300
        hover:bg-neutral-50
        active:bg-neutral-100
        focus:border-neutral-400 focus:ring-neutral-500/30
        """

      _ ->
        """
        text-white bg-neutral-700
        hover:bg-neutral-600
        active:bg-neutral-700
        focus:ring-neutral-500/30
        """
    end
  end

  defp class_color("info", variant) do
    case variant do
      "outline" ->
        """
        text-info-600 bg-white border-info-600
        hover:text-white hover:bg-info-600
        active:bg-info-700 active:border-info-700
        focus:ring-info-500/30
        """

      "monochrome" ->
        """
        text-neutral-700 bg-white border-neutral-300
        hover:bg-neutral-50
        active:bg-neutral-100
        focus:border-info-400 focus:ring-info-500/30
        """

      _ ->
        """
        text-white bg-info-700
        hover:bg-info-600
        active:bg-info-700
        focus:ring-info-500/30
        """
    end
  end

  defp class_color("success", variant) do
    case variant do
      "outline" ->
        """
        text-success-600 bg-white border-success-600
        hover:text-white hover:bg-success-600
        active:bg-success-700 active:border-success-700
        focus:ring-success-500/30
        """

      "monochrome" ->
        """
        text-neutral-700 bg-white border-neutral-300
        hover:bg-neutral-50
        active:bg-neutral-100
        focus:border-success-400 focus:ring-success-500/30
        """

      _ ->
        """
        text-white bg-success-700
        hover:bg-success-600
        active:bg-success-700
        focus:ring-success-500/30
        """
    end
  end

  defp class_color("warning", variant) do
    case variant do
      "outline" ->
        """
        text-warning-600 bg-white border-warning-600
        hover:text-white hover:bg-warning-600
        active:bg-warning-700 active:border-warning-700
        focus:ring-warning-500/30
        """

      "monochrome" ->
        """
        text-neutral-700 bg-white border-neutral-300
        hover:bg-neutral-50
        active:bg-neutral-100
        focus:border-warning-400 focus:ring-warning-500/30
        """

      _ ->
        """
        text-white bg-warning-700
        hover:bg-warning-600
        active:bg-warning-700
        focus:ring-warning-500/30
        """
    end
  end

  defp class_color("danger", variant) do
    case variant do
      "outline" ->
        """
        text-danger-600 bg-white border-danger-600
        hover:text-white hover:bg-danger-600
        active:bg-danger-700 active:border-danger-700
        focus:ring-danger-500/30
        """

      "monochrome" ->
        """
        text-neutral-700 bg-white border-neutral-300
        hover:bg-neutral-50
        active:bg-neutral-100
        focus:border-danger-400 focus:ring-danger-500/30
        """

      _ ->
        """
        text-white bg-danger-700
        hover:bg-danger-600
        active:bg-danger-700
        focus:ring-danger-500/30
        """
    end
  end
end
