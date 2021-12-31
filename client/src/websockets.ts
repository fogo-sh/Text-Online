import { TypedMessage } from "./types";

const VITE_WS_HOST = import.meta.env.VITE_WS_HOST as string ?? "ws://localhost:4000/ws";

const websocket = new WebSocket(VITE_WS_HOST);

const ready = new Promise((reject, resolve) => {
  websocket.onopen = () => {
    resolve();
  };
  websocket.onerror = (error) => {
    reject(error);
  };
});

const sendMessage = (message: string) => {
  const outgoingMessage: TypedMessage = {
    type: "message",
    message,
  };

  websocket.send(JSON.stringify(outgoingMessage));
};

export default { sendMessage, client: websocket, ready };
