defmodule TextOnline.MessageHandler do
  require Logger

  defp raw_reply(text, state) do
    {:reply, {:text, text}, state}
  end

  defp reply(:pong, state) do
    text = Jason.encode!(%{:type => :pong, :message => "pong"})
    raw_reply(text, state)
  end

  defp reply(:error, message, state) do
    text = Jason.encode!(%{:type => :error, :message => message})
    raw_reply(text, state)
  end

  defp reply(:ack, message, state) do
    text = Jason.encode!(%{:type => :ack, :message => message})
    raw_reply(text, state)
  end

  def handle_raw(text, state) when is_binary(text) do
    case Jason.decode(text) do
      {:ok, decoded} -> TextOnline.MessageHandler.handle(decoded, state)
      {:error, _error} -> reply(:error, "json decode error", state)
    end
  end

  def handle(%{"type" => "ping"}, state) do
    reply(:pong, state)
  end

  def handle(%{"type" => "message", "message" => message}, state) do
    message = "#{state.username}: #{message}"

    Registry.dispatch(Registry.TextOnline, state.room_key, fn entries ->
      for {pid, _} <- entries do
        if pid != self() do
          Logger.debug("#{inspect(self())} Sending #{inspect(pid)} message '#{inspect(message)}'")
          message = Jason.encode!(%{:type => :msg, :message => message})
          Process.send(pid, message, [])
        end
      end
    end)

    reply(:ack, message, state)
  end

  def handle(_, state) do
    reply(:error, "unknown message", state)
  end
end
