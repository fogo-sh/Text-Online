defmodule TextOnline.Router do
  use Plug.Router

  plug(:match)
  plug(:dispatch)

  get "/" do
    send_resp(conn, 200, "text-online")
  end

  match _ do
    send_resp(conn, 404, "404")
  end
end
