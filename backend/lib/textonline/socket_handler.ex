defmodule TextOnline.SocketHandler do
  @behaviour :cowboy_websocket

  @default_room "yard"

  require Logger

  def init(request, _state) do
    Logger.debug("#{inspect(self())} init: request #{inspect(request)}")
    {:cowboy_websocket, request, %{}}
  end

  def websocket_init(state) do
    Logger.debug("#{inspect(self())} websocket_init: state #{inspect(state)}")

    room_key = "room:" <> @default_room

    {:ok, _} =
      Registry.TextOnline
      |> Registry.register(room_key, %{})

    state = Map.put(state, :room_key, room_key)

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
