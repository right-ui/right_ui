defmodule RightUI.Overlay.Modal do
  use RightUI, :component
  alias Phoenix.LiveView.JS

  defmacro __using__(_) do
    quote do
      import RightUI.Overlay.Modal, only: [modal: 1]
    end
  end

  @doc """
  Renders a live component inside a modal.

  The rendered modal receives a `:return_to` option to properly update
  the URL when the modal is closed.

  ## Examples

  ```heex
  <.modal return_to={Routes.unit_index_path(@socket, :index)}>
    <.live_component
      module={AdminWeb.UnitLive.FormComponent}
      id={@unit.id || :new}
      title={@page_title}
      action={@live_action}
      unit={@unit}
      return_to={Routes.unit_index_path(@socket, :index)}
    />
  </.modal>
  ```

  ## Note

  ### Animation

  + The entering animation is handled by `alpinejs v3.x`.
  + The leaving animation is handled by `Phoenix.LiveView.JS`.

  ### No Scroll

  It's handled by `@alpinejs/focus v3.x`.

  """
  def modal(assigns) do
    assigns =
      assigns
      |> attr(:return_to, :string)
      |> attr(:class, :string)
      |> attr(:extra, :rest)
      |> attr_done()

    ~H"""
    <div
      id="modal"
      x-cloak
      x-data="{
        open: false,
        init: function() {
          trigger = function() { this.open = true }
          this.$nextTick(trigger.bind(this))
        }
      }"
      role="modal"
      aria-modal="true"
      class="fixed inset-0 z-10 overflow-y-auto"
      phx-remove={hide_modal()}
    >
      <div
        id="modal-overlay"
        x-show="open"
        x-transition:enter="transition ease-out duration-150"
        x-transition:enter-start="opacity-0"
        x-transition:enter-end="opacity-100"
        class="fixed inset-0 bg-black bg-opacity-50"
      >
      </div>

      <div
        x-show="open"
        x-transition:enter="transition ease-out duration-150"
        x-transition:enter-start="opacity-0 scale-90"
        x-transition:enter-end="opacity-100 scale-100"
        class="relative min-h-screen flex items-center justify-center p-4"
      >
        <div
          id="modal-panel"
          class={
            merge_class([
              "relative bg-white rounded-lg shadow-lg  shadow-xl overflow-y-auto",
              "align-bottom px-4 pt-5 pb-4",
              "sm:align-middle sm:max-w-xl sm:w-full sm:p-6 sm:my-8"
            ])
          }
          x-trap.noscroll.inert="open"
          phx-click-away={JS.dispatch("click", to: "#modal-close")}
          phx-key="escape"
          phx-window-keydown={JS.dispatch("click", to: "#modal-close")}
        >
          <%= if @return_to != "" do %>
            <%= live_patch("",
              to: @return_to,
              id: "modal-close",
              class: "hidden",
              phx_click: hide_modal()
            ) %>
          <% else %>
            <button type="button" id="modal-close" class="hidden" phx-click={hide_modal()}></button>
          <% end %>

          <%= render_slot(@inner_block) %>
        </div>
      </div>
    </div>
    """
  end

  defp hide_modal(js \\ %JS{}) do
    js
    |> JS.hide(
      transition: {
        "transition ease-out duration-150",
        "opacity-100",
        "opacity-0"
      },
      time: 150,
      to: "#modal-overlay"
    )
    |> JS.hide(
      transition: {
        "transition ease-out duration-150",
        "opacity-100 scale-100",
        "opacity-0 scale-90"
      },
      time: 150,
      to: "#modal-panel"
    )
  end
end
