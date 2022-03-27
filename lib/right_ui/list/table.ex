defmodule RightUI.List.Table do
  use RightUI, :component

  defmacro __using__(_) do
    quote do
      import RightUI.List.Table,
        only: [
          table: 1,
          thead: 1,
          tbody: 1,
          tr: 1,
          th: 1,
          td: 1
        ]
    end
  end

  def table(assigns) do
    assigns =
      assigns
      |> attr(:class, :string)
      |> attr(:inner_block, :slot, required: true)
      |> attr(:extra, :rest)
      |> attr_done()

    ~H"""
    <div class="-my-2 overflow-x-auto">
      <div class="inline-block min-w-full py-2 align-middle md:px-6 lg:px-8">
        <div class="overflow-hidden shadow ring-1 ring-black ring-opacity-5 md:rounded-lg">
          <table class="min-w-full divide-y divide-neutral-300">
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
      |> attr(:inner_block, :slot, required: true)
      |> attr(:extra, :rest)
      |> attr_done()

    ~H"""
    <thead class={merge_class(["bg-neutral-50", @class])} {@extra}>
      <%= render_slot(@inner_block) %>
    </thead>
    """
  end

  def tbody(assigns) do
    assigns =
      assigns
      |> attr(:divide, :boolean, default: true)
      |> attr(:class, :string)
      |> attr(:inner_block, :slot, required: true)
      |> attr(:extra, :rest)
      |> attr_done()

    ~H"""
    <tbody class={merge_class([tbody_class(@divide), "bg-white", @class])} {@extra}>
      <%= render_slot(@inner_block) %>
    </tbody>
    """
  end

  defp tbody_class(true), do: "divide-y divide-neutral-200"
  defp tbody_class(false), do: ""

  def tr(assigns) do
    assigns =
      assigns
      |> attr(:striped, :boolean, default: false)
      |> attr(:class, :string)
      |> attr(:inner_block, :slot, required: true)
      |> attr(:extra, :rest)
      |> attr_done()

    ~H"""
    <tr class={merge_class(tr_class(@striped), @class)} {@extra}>
      <%= render_slot(@inner_block) %>
    </tr>
    """
  end

  defp tr_class(true), do: "even:bg-neutral-50"
  defp tr_class(false), do: ""

  def th(assigns) do
    assigns =
      assigns
      |> attr(:position, :enum, values: ["first", "mid", "last"], default: "mid")
      |> attr(:class, :string)
      |> attr(:inner_block, :slot, required: true)
      |> attr(:extra, :rest)
      |> attr_done()

    ~H"""
    <th
      scope="col"
      class={
        merge_class([
          th_class_padding(@position),
          "text-left text-sm font-semibold text-neutral-900",
          @class
        ])
      }
      {@extra}
    >
      <%= render_slot(@inner_block) %>
    </th>
    """
  end

  defp th_class_padding("first"), do: "pl-4 pr-3 sm:pl-6 py-3.5"
  defp th_class_padding("mid"), do: "px-3 py-3.5"
  defp th_class_padding("last"), do: "pl-3 pr-4 sm:pr-6 py-3.5"

  def td(assigns) do
    assigns =
      assigns
      |> attr(:position, :enum, values: ["first", "mid", "last"], default: "mid")
      |> attr(:class, :string)
      |> attr(:inner_block, :slot, required: true)
      |> attr(:extra, :rest)
      |> attr_done()

    ~H"""
    <td
      class={
        merge_class([
          td_class_padding(@position),
          "whitespace-nowrap text-sm text-neutral-500",
          @class
        ])
      }
      {@extra}
    >
      <%= render_slot(@inner_block) %>
    </td>
    """
  end

  defp td_class_padding("first"), do: "pl-4 pr-3 sm:pl-6 py-4"
  defp td_class_padding("mid"), do: "px-3 py-4"
  defp td_class_padding("last"), do: "pl-3 pr-4 sm:pr-6 py-4"
end
