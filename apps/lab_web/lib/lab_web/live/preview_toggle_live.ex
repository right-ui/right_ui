defmodule LabWeb.PreviewToggleLive do
  use LabWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:attr1, false)
     |> assign(:attr2, true)}
  end

  def handle_event("event1", params, socket) do
    %{attr1: open} = socket.assigns
    {:noreply, assign(socket, :attr1, !open)}
  end

  def handle_event("event2", params, socket) do
    %{attr2: open} = socket.assigns
    {:noreply, assign(socket, :attr2, !open)}
  end

  def render(assigns) do
    ~H"""
    <div>
      <.toggle value={@attr1} event_name="event1" />
    </div>
    """
  end
end
