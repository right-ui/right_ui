defmodule RightUI.Element.Dropdown do
  use RightUI, :component

  defmacro __using__(_) do
    quote do
      import RightUI.Element.Dropdown, only: [dropdown: 1]
    end
  end

  def dropdown(assigns) do
    assigns =
      assigns
      |> attr(:trigger, :slot, required: true)
      |> attr(:inner_block, :slot, required: true)
      |> attr(:panel_position, :list, default: [:left])
      |> attr(:class_button, :string)
      |> attr(:class, :string)
      |> attr(:extra, :rest)
      |> attr_done()

    ~H"""
    <div
      x-data="{
          open: false,
          toggle() {
            this.open = this.open ? this.close() : true
          },
          close(focusAfter) {
            this.open = false
            focusAfter && focusAfter.focus()
          }
        }"
      x-on:keydown.escape.prevent.stop="close($refs.button)"
      x-on:focusin.window="!$refs.panel.contains($event.target) && close()"
      x-id="['dropdown-panel']"
      class={merge_class(["relative", @class])}
      {@extra}
    >
      <button
        x-ref="button"
        x-on:click="toggle()"
        x-bind:aria-expanded="open"
        x-bind:aria-controls="$id('dropdown-panel')"
        type="button"
        class={@class_button}
      >
        <%= render_slot(@trigger) %>
      </button>

      <div
        x-ref="panel"
        x-cloak
        x-show="open"
        x-transition.opacity
        x-on:click.outside="close($refs.button)"
        x-bind:id="$id('dropdown-panel')"
        class={"absolute #{transform_panel_position(@panel_position)}"}
      >
        <%= render_slot(@inner_block) %>
      </div>
    </div>
    """
  end

  defp transform_panel_position(positions) do
    positions
    |> Enum.map(fn position ->
      case position do
        :left -> "left-0"
        :right -> "right-0"
        :top -> "top-0"
        :bottom -> "bottom-0"
        _ -> ""
      end
    end)
    |> merge_class()
  end
end
