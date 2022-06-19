defmodule LabWeb.PreviewFlashLive do
  use LabWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_event("notify-info", _params, socket) do
    {:noreply, put_flash(socket, :info, "Info")}
  end

  def handle_event("notify-success", _params, socket) do
    {:noreply, put_flash(socket, :success, "Success")}
  end

  def handle_event("notify-error", _params, socket) do
    {:noreply, put_flash(socket, :error, "Error")}
  end

  def handle_params(_params, _uri, socket) do
    {:noreply, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="flex flex-col">
      <button phx-click="notify-info">Dispatch Notification - info</button>
      <button phx-click="notify-success">Dispatch Notification - success</button>
      <button phx-click="notify-error">Dispatch Notification - error</button>
    </div>

    <.flash flash={@flash} class="container pt-6" />
    """
  end
end
