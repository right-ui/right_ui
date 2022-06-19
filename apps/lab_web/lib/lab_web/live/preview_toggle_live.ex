defmodule LabWeb.PreviewToggleLive do
  use LabWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:send_mail, false)
     |> assign(:silent_mode, true)}
  end

  def handle_event("event1", params, socket) do
    %{send_mail: send_mail} = socket.assigns
    {:noreply, assign(socket, :send_mail, !send_mail)}
  end

  def handle_event("event2", params, socket) do
    %{silent_mode: silent_mode} = socket.assigns
    {:noreply, assign(socket, :silent_mode, !silent_mode)}
  end

  def render(assigns) do
    ~H"""
    <div class="space-y-4">
      <.toggle
        id="toggle-1"
        class="flex justify-between items-center"
        value={@send_mail}
        event_name="event1"
      >
        <:label>
          <span class="text-neutral-500">
            send mail
          </span>
        </:label>
      </.toggle>

      <.toggle
        id="toggle-2"
        class="flex justify-between items-center"
        value={@send_mail}
        event_name="event1"
      >
        <:label>
          <span class="text-neutral-500">
            send mail (duplicated)
          </span>
        </:label>
      </.toggle>

      <.toggle
        id="toggle-3"
        class="flex justify-between items-center"
        value={@silent_mode}
        event_name="event2"
      >
        <:label>
          <span class="text-neutral-500">
            silent mode
          </span>
        </:label>
      </.toggle>
    </div>
    """
  end
end
