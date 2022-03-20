defmodule RightUI.List.Table do
  use RightUI, :component

  def table(assigns) do
    assigns =
      assigns
      |> attr(:class, :string)
      |> attr(:extra, :rest, exclude: [:class])

    ~H"""
    <div class="-my-2 overflow-x-auto">
      <div class="inline-block min-w-full py-2 align-middle md:px-6 lg:px-8">
        <div class="overflow-hidden shadow ring-1 ring-black ring-opacity-5 md:rounded-lg">
          <table class="min-w-full divide-y divide-gray-300">
            <%= render_slot(@inner_block) %>
          </table>
        </div>
      </div>
    </div>
    """
  end

  def thead(assigns) do
    assigns =
      assigns
      |> attr(:class, :string)
      |> attr(:extra, :rest, exclude: [:class])

    ~H"""
    <thead class={merge_class("bg-gray-50", @class)} {@extra}>
      <%= render_slot(@inner_block) %>
    </thead>
    """
  end

  def tbody(assigns) do
    assigns =
      assigns
      |> attr(:class, :string)
      |> attr(:divide, :boolean, default: true)
      |> attr(:extra, :rest, exclude: [:class, :divide])

    ~H"""
    <tbody class={merge_class([tbody_class(@divide), "bg-white", @class])} {@extra}>
      <%= render_slot(@inner_block) %>
    </tbody>
    """
  end

  def tbody_class(true), do: "divide-y divide-gray-200"
  def tbody_class(false), do: ""

  def tr(assigns) do
    assigns =
      assigns
      |> attr(:class, :string)
      |> attr(:striped, :boolean, default: false)
      |> attr(:extra, :rest, exclude: [:class, :striped])

    ~H"""
    <tr class={merge_class(tr_class(@striped), @class)} {@extra}>
      <%= render_slot(@inner_block) %>
    </tr>
    """
  end

  def tr_class(true), do: "even:bg-gray-50"
  def tr_class(false), do: ""

  def th(assigns) do
    assigns =
      assigns
      |> attr(:class, :string)
      |> attr(:position, :enum, values: [:first, :mid, :last], default: :mid)
      |> attr(:extra, :rest, exclude: [:class, :position])

    ~H"""
    <th scope="col" class={
        merge_class([
          th_padding_class(@position),
          "text-left text-sm font-semibold text-gray-900",
          @class
        ])
      }
      {@extra}
    >
      <%= if @inner_block do %>
        <%= render_slot(@inner_block) %>
      <% end %>
    </th>
    """
  end

  def th_padding_class(:first), do: "pl-4 pr-3 sm:pl-6 py-3.5"
  def th_padding_class(:mid), do: "px-3 py-3.5"
  def th_padding_class(:last), do: "pl-3 pr-4 sm:pr-6 py-3.5"

  def td(assigns) do
    assigns =
      assigns
      |> attr(:class, :string)
      |> attr(:position, :enum, values: [:first, :mid, :last], default: :mid)
      |> attr(:extra, :rest, exclude: [:class, :position])

    ~H"""
    <td class={
        merge_class([
          td_padding_class(@position),
          "whitespace-nowrap text-sm text-gray-500",
          @class
        ])
      }
      {@extra}
    >
      <%= if @inner_block do %>
        <%= render_slot(@inner_block) %>
      <% end %>
    </td>
    """
  end

  def td_padding_class(:first), do: "pl-4 pr-3 sm:pl-6 py-4"
  def td_padding_class(:mid), do: "px-3 py-4"
  def td_padding_class(:last), do: "pl-3 pr-4 sm:pr-6 py-4"
end
