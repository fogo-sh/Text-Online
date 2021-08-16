defmodule TextOnline.MessageHandler do
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

  def handle_raw(text, state) when is_binary(text) do
    case Jason.decode(text) do
      {:ok, decoded} -> TextOnline.MessageHandler.handle(decoded, state)
      {:error, _error} -> reply(:error, "json decode error", state)
    end
  end

  def handle(%{"type" => "ping"}, state) do
    reply(:pong, state)
  end

  def handle(_, state) do
    reply(:error, "unknown message", state)
  end
end
