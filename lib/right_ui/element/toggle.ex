defmodule RightUI.Element.Toggle do
  use RightUI, :component

  defmacro __using__(_) do
    quote do
      import RightUI.Element.Toggle, only: [toggle: 1]
    end
  end

  def toggle(assigns) do
    assigns =
      assigns
      |> attr(:id, :string, default: "toggle")
      |> attr(:label_id, :string, default: "toggle-label")
      |> attr(:value, :boolean, required: true)
      |> attr(:event_name, :string, default: "toggle")
      |> attr(:extra, :rest)
      |> attr_done()

    ~H"""
    <div id={@id} class="flex items-center">
      <label
        id={@label_id}
        phx-click={toggle_value(@event_name, assigns)}
        class="text-black transition-colors dark:text-white"
      >
        Send notifications
      </label>
      <button
        type="button"
        role="switch"
        class={~m"
          ml-4 relative w-14 py-1 px-0 inline-flex
          rounded-full border-2 border-transparent
          focus-outline-none focus-ring-2 focus-ring-primary-400
          transition ease-out duration-300
          #{if @value, do: "bg-primary-200", else: "bg-neutral-200"}
        "}
        phx-throttle="300"
        phx-click={toggle_value(@event_name, assigns)}
        aria-checked={@value}
        aria-labelledby={@label_id}
      >
        <span class={~m"
            w-6 h-6 rounded-full bg-white
            transition ease-out duration-300
            #{if @value, do: "translate-x-6", else: "translate-x-1"}
          "}></span>
      </button>
    </div>
    """
  end

  defp toggle_value(event, %{value: false, id: id}) do
    %JS{}
    |> JS.push(event, value: %{current: false})
    |> JS.add_class("bg-primary-200", transition: "bg-neutral-200", to: "##{id} button", time: 300)
    |> JS.add_class("translate-x-6", transition: "translate-x-1", to: "##{id} span", time: 300)
  end

  defp toggle_value(event, %{value: true, id: id}) do
    %JS{}
    |> JS.push(event, value: %{current: true})
    |> JS.add_class("bg-neutral-200", transition: "bg-primary-200", to: "##{id} button", time: 300)
    |> JS.add_class("translate-x-1", transition: "translate-x-6", to: "##{id} span", time: 300)
  end
end
