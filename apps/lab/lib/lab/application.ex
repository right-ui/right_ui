defmodule Lab.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the PubSub system
      {Phoenix.PubSub, name: Lab.PubSub}
      # Start a worker by calling: Lab.Worker.start_link(arg)
      # {Lab.Worker, arg}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: Lab.Supervisor)
  end
end
