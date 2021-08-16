defmodule TextOnline.SocketHandler do
  @behaviour :cowboy_websocket

  @default_room "yard"

  require Logger

  def init(request, _state) do
    Logger.debug("init: #{inspect(request)}")
    {:cowboy_websocket, request, {}}
  end

  def websocket_init(state) do
    Logger.debug("websocket_init: #{inspect(state)}")

    {:ok, _} =
      Registry.TextOnline
      |> Registry.register("room:" <> @default_room, {})

    {:ok, state}
  end

  def websocket_handle({:text, text} = data, state) do
    Logger.debug("websocket_handle: #{inspect(data)}")
    TextOnline.MessageHandler.handle_raw(text, state)
  end

  def websocket_info(info, state) do
    Logger.debug("websocket_info: #{inspect(info)}")
    {:reply, {:text, info}, state}
  end
end
