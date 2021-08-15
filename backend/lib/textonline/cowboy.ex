defmodule TextOnline.Cowboy do
  use GenServer

  @cowboy_server __MODULE__

  def start_link(_) do
    GenServer.start_link(@cowboy_server, :no_args, name: @cowboy_server)
  end

  def init(:no_args) do
    {:ok, _} = :cowboy.start_clear(:http, [{:port, 4000}], %{env: %{dispatch: dispatch()}})
    IO.puts("Started Cowboy server")
    {:ok, nil}
  end

  def terminate(_, state) do
    :ok = :cowboy.stop_listener(:http)
    {:shutdown, state}
  end

  defp dispatch do
    :cowboy_router.compile([
      {:_,
       [
         {"/ws", TextOnline.SocketHandler, []}
       ]}
    ])
  end
end
