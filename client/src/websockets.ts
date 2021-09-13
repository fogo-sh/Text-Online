import { TypedMessage } from "./types";

const websocket = new WebSocket("ws://localhost:4000/ws");

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
