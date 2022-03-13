defmodule RightUI.Layout.Container do
  use RightUI, :component

  def container(assigns) do
    assigns =
      assigns
      |> attr(:class, :string)
      |> attr(:padding, :enum, values: [:always, :sm], default: :sm)
      |> attr(:breakpoint, :boolean, default: false)
      |> attr(:extra, :rest, exclude: [:class, :padding, :breakpoint])

    ~H"""
    <div
      class={
        @breakpoint
        |> container_class()
        |> merge_class(@class)
      }
      {@extra}
    >
      <div class={padding_class(@padding)}>
        <%= render_slot(@inner_block) %>
      </div>
    </div>
    """
  end

  def container_class(true), do: "container max-w-7xl mx-auto"
  def container_class(false), do: "max-w-7xl mx-auto"

  def padding_class(:always), do: "px-4 sm:px-6 lg:px-8"
  def padding_class(:sm), do: "sm:px-6 lg:px-8"
end
