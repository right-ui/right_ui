defmodule RightUI.Layout.Container do
  use RightUI, :component

  defmacro __using__(_) do
    quote do
      import RightUI.Layout.Container, only: [container: 1]
    end
  end

  def container(assigns) do
    assigns =
      assigns
      |> attr(:class, :string)
      |> attr(:breakpoint, :boolean, default: false)
      |> attr(:center, :boolean, default: true)
      |> attr(:padding, :enum, values: ["always", "sm"], default: "always")
      |> attr(:reverse, :boolean, default: false)
      |> attr(:inner_block, :slot, required: true)
      |> attr(:extra, :rest)
      |> attr_done()

    ~H"""
    <div
      class={
        merge_class([
          class_breakpoint(@breakpoint),
          class_center(@center),
          class_padding(@padding, @reverse),
          @class
        ])
      }
      {@extra}
    >
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  defp class_center(true), do: "mx-auto"
  defp class_center(false), do: ""

  defp class_breakpoint(true), do: "container"
  defp class_breakpoint(false), do: ""

  defp class_padding("always", false), do: "px-4 sm:px-6 lg:px-8"
  defp class_padding("always", true), do: "-mx-4 sm:-mx-6 lg:-mx-8"
  defp class_padding("sm", false), do: "sm:px-6 lg:px-8"
  defp class_padding("sm", true), do: "sm:-mx-6 lg:-mx-8"
end
