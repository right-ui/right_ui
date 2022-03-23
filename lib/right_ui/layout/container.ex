defmodule RightUI.Layout.Container do
  use RightUI, :component

  def container(assigns) do
    assigns =
      assigns
      |> attr(:class, :string)
      |> attr(:center, :boolean, default: true)
      |> attr(:breakpoint, :boolean, default: false)
      # add padding from which breakpoint
      |> attr(:padding, :enum, values: [:always, :sm], default: :always)
      |> attr(:reverse, :boolean, default: false)
      |> attr(:extra, :rest, exclude: [:class, :padding, :reverse, :breakpoint])

    ~H"""
    <div
      class={
        merge_class([
          center_class(@breakpoint),
          breakpoint_class(@breakpoint)
        ])
      }
      {@extra}
    >
      <div
        class={
          merge_class([
            padding_class(@padding, @reverse),
            @class
          ])
        }
      >
        <%= render_slot(@inner_block) %>
      </div>
    </div>
    """
  end

  def center_class(true), do: "mx-auto"
  def center_class(false), do: ""

  def breakpoint_class(true), do: "container"
  def breakpoint_class(false), do: ""

  def padding_class(:always, false), do: "px-4 sm:px-6 lg:px-8"
  def padding_class(:always, true), do: "-mx-4 sm:-mx-6 lg:-mx-8"
  def padding_class(:sm, false), do: "sm:px-6 lg:px-8"
  def padding_class(:sm, true), do: "sm:-mx-6 lg:-mx-8"
end
