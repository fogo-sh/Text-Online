import { TypedMessage } from "./types";

const WS_HOST =
  (import.meta.env.TEXTONLINE_WS_HOST as string) ?? "ws://localhost:4000/ws";

export const client = new WebSocket(WS_HOST);

export const ready = new Promise((reject, resolve) => {
  client.onopen = () => {
    resolve();
  };
  client.onerror = (error) => {
    reject(error);
  };
});

export const sendMessage = (message: string) => {
  const outgoingMessage: TypedMessage = {
    type: "message",
    message,
  };

  client.send(JSON.stringify(outgoingMessage));
};
