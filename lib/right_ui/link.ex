defmodule RightUI.Link do
  use RightUI, :component

  defmacro __using__(_) do
    quote do
      import RightUI.Link, only: [link: 1]
    end
  end

  def link(assigns) do
    assigns =
      assigns
      |> attr(:type, :enum, values: ["a", "live_patch", "live_redirect"], default: "a")
      |> attr(:to, :string, required: true)
      |> attr(:class, :string)
      |> attr(:inner_block, :slot, required: true)
      |> attr(:extra, :rest, exclude: [:type, :to, :class, :inner_block])

    ~H"""
    <%= apply(link_function(@type), [
      [to: @to, class: @class] ++ @extra,
      [do: render_slot(@inner_block)]
    ]) %>
    """
  end

  defp link_function("a"), do: &Phoenix.HTML.Link.link/2
  defp link_function("live_path"), do: &live_patch/2
  defp link_function("live_redirect"), do: &live_redirect/2
end
