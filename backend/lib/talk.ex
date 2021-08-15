defmodule TextOnline do
  def hello do
    :world
  end

  def send_message_to_client(msg) when is_bitstring(msg) do
    :erlang.send(get_socket_handler_pid(), {:msg, msg})
  end

  def get_socket_handler_pid, do: :global.whereis_name(:textonline_socket)
end
