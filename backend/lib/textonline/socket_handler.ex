defmodule TextOnline.SocketHandler do
  @behaviour :cowboy_websocket

  require Logger

  def init(request, _state) do
    Logger.info("init: #{inspect(request)}")
    {:cowboy_websocket, request, {}}
  end

  def websocket_init(state) do
    Logger.info("websocket_init: #{inspect(state)}")
    {:ok, state}
  end

  def websocket_handle({:text, text} = data, state) do
    Logger.info("websocket_handle: #{inspect(data)}")
    {:reply, {:text, text}, state}
  end

  def websocket_info(info, state) do
    Logger.info("websocket_info: #{inspect(info)}")
    {:reply, {:text, info}, state}
  end
end
