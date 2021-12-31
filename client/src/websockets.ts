import { log } from "./log";
import { TypedMessage } from "./types";

const WS_HOST =
  (import.meta.env.TEXTONLINE_WS_HOST as string) ?? "ws://localhost:4000/ws";

const connectClient = () => {
  const client = new WebSocket(WS_HOST);
  log(`Connecting to websocket using ${WS_HOST}`, client);
  return client;
};

export const client = connectClient();

export const sendMessage = (message: string) => {
  const outgoingMessage: TypedMessage = {
    type: "message",
    message,
  };

  log("Sending message", outgoingMessage);
  client.send(JSON.stringify(outgoingMessage));
};
