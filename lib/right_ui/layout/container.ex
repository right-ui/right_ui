defmodule RightUI.Layout.Container do
  use RightUI, :component

  def container(assigns) do
    assigns =
      assigns
      |> attr(:class, :string)
      # add padding from which breakpoint
      |> attr(:padding, :enum, values: [:always, :sm], default: :sm)
      |> attr(:reverse, :boolean, default: false)
      |> attr(:breakpoint, :boolean, default: false)
      |> attr(:extra, :rest, exclude: [:class, :padding, :reverse, :breakpoint])

    ~H"""
    <div
      class={merge_class(container_class(@breakpoint), @class)}
      {@extra}
    >
      <div class={padding_class(@padding, @reverse)}>
        <%= render_slot(@inner_block) %>
      </div>
    </div>
    """
  end

  def container_class(true), do: "container mx-auto"
  def container_class(false), do: "mx-auto"

  def padding_class(:always, false), do: "px-4 sm:px-6 lg:px-8"
  def padding_class(:always, true), do: "-mx-4 sm:-mx-6 lg:-mx-8"
  def padding_class(:sm, false), do: "sm:px-6 lg:px-8"
  def padding_class(:sm, true), do: "sm:-mx-6 lg:-mx-8"
end
