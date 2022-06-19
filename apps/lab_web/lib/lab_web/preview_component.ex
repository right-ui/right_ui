defmodule LabWeb.PreviewComponent do
  use RightUI, :component
  alias LabWeb.Router.Helpers, as: Routes

  def preview_container(assigns) do
    assigns =
      assigns
      |> attr(:inner_block, :slot, required: true)
      |> attr_done()

    ~H"""
    <div class="space-y-20">
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  def preview(assigns) do
    assigns =
      assigns
      |> attr(:title, :string, required: true)
      |> attr_done()

    ~H"""
    <div>
      <div class="flex items-center mb-3 whitespace-nowrap">
        <h3 class="font-medium text-neutral-900 truncate"><%= @title %></h3>
      </div>
      <div
        class="bg-neutral-500 rounded-lg overflow-hidden ring-1 ring-neutral-900 ring-opacity-5"
        x-data="resizableIframe()"
      >
        <div class="relative min-w-full sm:min-w-[375px] max-w-full sm:pr-4 bg-white" x-ref="root">
          <iframe
            x-ref="iframe"
            title={@title}
            aria-label={@title}
            name={generate_iframe_id()}
            class="w-full rounded-lg overflow-hidden sm:rounded-r-none"
            srcdoc={to_srcdoc(assigns)}
          >
          </iframe>
          <!--
               The mask for iframe.

               When using iframe, there are two browsing contexts:
               + one for current document
               + one for the iframe

               Suppose that a `pointermove` event listener is defined in current document, when pointer
               is moving on the iframe, the defined event listener won't be trigged. Because the browsing
               contexts are different.

               In order to make `pointermove` event listener works as expected. There's a possible solution:
               1. create a mask on the iframe
               2. when `pointermove` is not listened, set `pointer-events: none` which makes sure
                  that the iframe can be inspected as expected.
               3. when `pointermove` is listened, set `pointer-events: auto` which make sure that
                  the event is always emitted from current document.
          -->
          <div
            class="hidden absolute opacity-0 inset-0 mr-4 sm:block "
            :class="{ 'pointer-events-none': !resizing }"
            x-ref="mask"
          >
          </div>

          <div
            class="sr-only sm:not-sr-only
                   sm:absolute sm:inset-y-0 sm:right-0 sm:w-4
                   sm:flex sm:items-center
                   sm:border-l sm:border-neutral-200 sm:bg-neutral-100 cursor-[ew-resize]"
            x-ref="handle"
            @pointerdown="onResizeStart($event)"
          >
            <!-- bigger interactive area -->
            <div class="absolute inset-y-0 -inset-x-2"></div>
            <svg
              aria-hidden="true"
              class="h-4 w-4 text-neutral-600 pointer-events-none"
              fill="currentColor"
              viewBox="0 0 24 24"
            >
              <path d="M8 5h2v14H8zM14 5h2v14h-2z"></path>
            </svg>
          </div>
        </div>
      </div>
    </div>
    """
  end

  def box(assigns) do
    assigns =
      assigns
      |> attr(:class, :string)
      |> attr(:extra, :rest, exclude: [:class])

    ~H"""
    <svg
      class={~m(
        border-2 border-dashed border-neutral-300 bg-white h-64 w-full text-neutral-200
        #{@class}
      )}
      preserveAspectRatio="none"
      stroke="currentColor"
      fill="none"
      viewBox="0 0 200 200"
      aria-hidden="true"
    >
      <path vector-effect="non-scaling-stroke" stroke-width="2" d="M0 0l200 200M0 200L200 0"></path>
    </svg>
    """
  end

  defp to_srcdoc(assigns) do
    html = ~H"""
    <!doctype html>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
    <link rel="stylesheet" href={Routes.static_path(LabWeb.Endpoint, "/assets/iframe.css")} />
    <script src={Routes.static_path(LabWeb.Endpoint, "/assets/iframe.js")}>
    </script>
    <body class="antialiased font-sans bg-neutral-200 overflow-hidden">
      <div class="bg-neutral-100">
        <!-- [component] start -->
        <%= render_slot(@inner_block) %>
        <!-- [component] end -->
      </div>
    </body>
    """

    # from Phoenix.LiveViewTest.rendered_to_string
    # https://github.com/phoenixframework/phoenix_live_view/blob/30ee942b3a18a9e2e1f222a76a707bfba7bd94f7/lib/phoenix_live_view/test/live_view_test.ex#L518
    html
    |> Phoenix.HTML.html_escape()
    |> Phoenix.HTML.safe_to_string()
  end

  defp generate_iframe_id() do
    id = :crypto.strong_rand_bytes(10) |> Base.url_encode64() |> binary_part(0, 10)
    "iframe-#{id}"
  end
end
