defmodule TextOnline.SocketHandler do
  @behaviour :cowboy_websocket

  @default_room "yard"

  require Logger

  @spec init(:cowboy_req.req(), any) :: {:cowboy_websocket, :cowboy_req.req(), map}
  def init(request, _state) do
    Logger.debug("#{inspect(self())} init: request #{inspect(request)}")

    username = inspect(self())
    room_key = "room:" <> @default_room

    state = %{
      username: username,
      room_key: room_key
    }

    {:cowboy_websocket, request, state}
  end

  @spec websocket_init(map) :: {:ok, map}
  def websocket_init(state = %{room_key: room_key}) do
    Logger.debug("#{inspect(self())} websocket_init: state #{inspect(state)}")

    {:ok, _} =
      Registry.TextOnline
      |> Registry.register(room_key, %{})

    {:ok, state}
  end

  def websocket_handle({:text, text} = data, state) do
    Logger.debug("#{inspect(self())} websocket_handle: info #{inspect(data)}")
    Logger.debug("#{inspect(self())} websocket_handle: state #{inspect(state)}")
    TextOnline.MessageHandler.handle_raw(text, state)
  end

  def websocket_info(info, state) do
    Logger.debug("#{inspect(self())} websocket_info: info #{inspect(info)}")
    Logger.debug("#{inspect(self())} websocket_info: state #{inspect(state)}")
    {:reply, {:text, info}, state}
  end
end
