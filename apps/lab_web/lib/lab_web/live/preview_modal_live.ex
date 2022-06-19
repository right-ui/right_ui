defmodule LabWeb.PreviewModalLive do
  use LabWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:open, false)}
  end

  def handle_params(_params, _uri, socket) do
    {:noreply, socket}
  end

  def render(assigns) do
    ~H"""
    <div>
      <%= live_patch("Click to open a modal via `modal`",
        to: Routes.preview_modal_path(@socket, :popup)
      ) %>
    </div>

    <%= if @live_action in [:popup] do %>
      <.modal return_to={Routes.preview_modal_path(@socket, :index)}>
        <p class="text-center">Hello World</p>
      </.modal>
    <% end %>
    """
  end
end
