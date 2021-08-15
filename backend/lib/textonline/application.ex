defmodule TextOnline.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      TextOnline.Cowboy
    ]

    opts = [strategy: :one_for_one, name: TextOnline.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
