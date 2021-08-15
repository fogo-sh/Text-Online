defmodule TextOnline do
  use Application

  def start(_type, _args) do
    children = [
      Plug.Cowboy.child_spec(
        scheme: :http,
        plug: TextOnline.Router,
        options: [
          dispatch: dispatch(),
          port: 4000
        ]
      ),
      Registry.child_spec(
        keys: :duplicate,
        name: Registry.TextOnline
      )
    ]

    opts = [strategy: :one_for_one, name: TextOnline.Application]
    Supervisor.start_link(children, opts)
  end

  defp dispatch do
    [
      {:_,
       [
         {"/ws/", TextOnline.SocketHandler, []},
         {:_, Plug.Cowboy.Handler, {TextOnline.Router, []}}
       ]}
    ]
  end
end
