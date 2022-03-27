defmodule RightUI.Navigation.Pagination do
  use RightUI, :component
  use RightUI.Element.Link
  use RightUI.Icon.HeroIcon

  defmacro __using__(_) do
    quote do
      import RightUI.Navigation.Pagination, only: [pagination: 1]
    end
  end

  def pagination(assigns) do
    assigns =
      assigns
      |> attr(:type, :enum, values: ["simple", "full"], default: "full")
      |> attr(:link_type, :enum, values: ["a", "live_patch", "live_redirect"], default: "a")
      |> attr(:fn_path, :function, required: true)
      |> attr(:total_pages, :integer, required: true)
      |> attr(:current_page, :integer, required: true)
      |> attr(:sibling_count, :integer, default: 2)
      |> attr(:class, :string)
      |> attr(:extra, :rest)
      |> attr_done()

    render(assigns.type, assigns)
  end

  defp render("simple", assigns) do
    ~H"""
    <nav class={merge_class(["flex-1 flex justify-between", @class])} aria-label="Pagination">
      <%= if @current_page > 1 do %>
        <.link type={@link_type} to={@fn_path.(@current_page - 1)} class={class_simple()}>
          Previous
        </.link>
      <% end %>

      <div class="grow"></div>

      <%= if @current_page < @total_pages do %>
        <.link
          type={@link_type}
          to={@fn_path.(@current_page + 1)}
          class={merge_class(["ml-3", class_simple()])}
        >
          Next
        </.link>
      <% end %>
    </nav>
    """
  end

  defp render("full", assigns) do
    ~H"""
    <nav
      class={
        merge_class([
          "relative z-0 inline-flex rounded-md shadow-sm -space-x-px",
          @class
        ])
      }
      aria-label="Pagination"
    >
      <%= if show_prev(@current_page, @sibling_count) do %>
        <.link type={@link_type} to={@fn_path.(1)} class={class_full_prev_or_next()}>
          <span class="sr-only">First</span>
          <span class="w-5 h-5 flex justify-center items-center">
            <.heroicon name="solid/chevron-double-left" class="w-4 h-4" enable_default_size={false} />
          </span>
        </.link>

        <.link type={@link_type} to={@fn_path.(@current_page - 1)} class={class_full_prev_or_next()}>
          <span class="sr-only">Previous</span>
          <.heroicon name="solid/chevron-left" />
        </.link>
      <% end %>

      <%= for page <- page_range(@current_page, @sibling_count, @total_pages) do %>
        <.link
          type={@link_type}
          to={@fn_path.(page)}
          class={if page == @current_page, do: class_full_current(), else: class_full_normal()}
        >
          <%= page %>
        </.link>
      <% end %>

      <%= if show_next(@current_page, @sibling_count, @total_pages) do %>
        <.link type={@link_type} to={@fn_path.(@current_page + 1)} class={class_full_prev_or_next()}>
          <span class="sr-only">Next</span>
          <.heroicon name="solid/chevron-right" />
        </.link>

        <.link type={@link_type} to={@fn_path.(@total_pages)} class={class_full_prev_or_next()}>
          <span class="sr-only">Last</span>
          <span class="w-5 h-5 flex justify-center items-center">
            <.heroicon name="solid/chevron-double-right" class="w-4 h-4" enable_default_size={false} />
          </span>
        </.link>
      <% end %>
    </nav>
    """
  end

  @class_shared one_line_class("""
                relative inline-flex items-center py-2
                border text-sm font-medium

                """)

  @class_color_active one_line_class("""
                      z-10
                      bg-primary-50
                      border-primary-500 text-primary-600
                      first:rounded-l-md last:rounded-r-md
                      """)

  @class_color_inactive one_line_class("""
                        bg-white
                        border-neutral-300
                        text-neutral-500 hover:bg-neutral-50
                        first:rounded-l-md last:rounded-r-md
                        """)

  @class_simple one_line_class("""
                bg-white
                border-neutral-300
                text-gray-700 hover:bg-neutral-50
                rounded-md
                """)

  defp class_simple(), do: "#{@class_shared} #{@class_simple} px-4"

  defp class_full_current(), do: "#{@class_shared} #{@class_color_active} px-4"
  defp class_full_normal(), do: "#{@class_shared} #{@class_color_inactive} px-4"
  defp class_full_prev_or_next(), do: "#{@class_shared} #{@class_color_inactive} px-2"

  defp show_prev(current, sibling_count) do
    current - sibling_count > 1
  end

  defp show_next(current, sibling_count, total) do
    current + sibling_count < total
  end

  defp page_range(current, sibling_count, total) do
    from = current - sibling_count
    to = current + sibling_count

    cond do
      to > total ->
        left_offset = to - total
        from = max(from - left_offset, 1)
        to = total
        from..to

      from < 1 ->
        right_offset = 1 - from
        from = 1
        to = min(to + right_offset, total)
        from..to

      true ->
        from..to
    end
  end
end
