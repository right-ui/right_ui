defmodule RightUI.Overlay.Flash do
  use RightUI, :component
  import RightUI.Icon.HeroIcon, only: [heroicon: 1]

  defmacro __using__(_) do
    quote do
      import RightUI.Overlay.Flash, only: [flash: 1]
    end
  end

  @doc """
  Provide an fancy flash.

  ## Example

  ```heex
  <.flash flash={@flash} class="container pt-6" />
  ```

  """
  def flash(assigns) do
    assigns =
      assigns
      |> attr(:flash, :map, required: true)
      |> attr(:class, :string)
      |> attr(:extra, :rest)
      |> attr_done()

    ~H"""
    <div class={~m(
        fixed inset-0 space-y-4
        flex flex-col items-center sm:items-end
        pointer-events-none
        #{@class}
      )}>
      <%= render_flash(@flash, :info) %>
      <%= render_flash(@flash, :success) %>
      <%= render_flash(@flash, :error) %>
    </div>
    """
  end

  defp render_flash(flash, key) when is_atom(key) do
    assigns = %{}

    ~H"""
    <%= if live_flash(flash, key) do %>
      <div
        id={flash_id(key)}
        x-data="{
          open: false,
          init: function() {
            this.$nextTick(() => { this.open = true })

            setTimeout(() => {
              var button = $refs['button-close']
              button && button.dispatchEvent(new Event('click', {bubbles: true}))
            }, 3000)
          }
        }"
        x-cloak
        x-show="open"
        x-description={"#{key} message"}
        x-transition:enter="transition ease-out duration-300"
        x-transition:enter-start="opacity-0 -translate-y-2 sm:translate-y-0 sm:translate-x-2"
        x-transition:enter-end="opacity-100 translate-y-0 sm:translate-x-0"
        class="max-w-sm w-full bg-white shadow-lg rounded-lg ring-1 ring-black ring-opacity-5 overflow-hidden pointer-events-auto"
      >
        <div class="flex items-start p-4">
          <div class="flex-shrink-0">
            <.heroicon name={icon_name(key)} class={"h-6 w-auto #{icon_color(key)}"} />
          </div>
          <div class="ml-3 pt-0.5 w-0 flex-1">
            <p class="text-sm leading-5 font-medium text-neutral-900">
              <%= live_flash(flash, key) %>
            </p>
          </div>
          <div class="ml-4 pt-0.5 flex-shrink-0 flex">
            <button
              x-ref="button-close"
              class="inline-flex text-neutral-400 hover:text-neutral-500 focus:outline-none transition ease-in-out duration-150"
              phx-click={hide_flash(key)}
            >
              <.heroicon name="solid/x" class="w-5 h-auto" />
            </button>
          </div>
        </div>
      </div>
    <% end %>
    """
  end

  defp icon_name(:info), do: "outline/information-circle"
  defp icon_name(:success), do: "outline/check-circle"
  defp icon_name(:error), do: "outline/exclamation-circle"

  defp icon_color(:info), do: "text-info-600"
  defp icon_color(:success), do: "text-success-600"
  defp icon_color(:error), do: "text-danger-600"

  defp hide_flash(js \\ %JS{}, key) do
    js
    |> JS.hide(
      transition: {
        "transition ease-in duration-300",
        "opacity-100 scale-100",
        "opacity-0 scale-95"
      },
      time: 300,
      to: "##{flash_id(key)}"
    )
    |> JS.push("lv:clear-flash", value: %{key: key})
  end

  defp flash_id(key), do: "flash-#{key}"
end
