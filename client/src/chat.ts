import { IncomingMessage } from "./types";
import websockets from "./websockets";

const renderMessage = ({ message }: IncomingMessage) => {
  const messageElement = document.createElement("div");
  messageElement.className = "message";
  messageElement.innerText = `Mitch: ${message}`;
  return messageElement;
};

const render = (message: IncomingMessage) => {
  switch (message.type) {
    case "ack":
      return renderMessage(message);
    case "msg":
      return renderMessage(message);
    default:
      throw new Error(`Unknown message type`);
  }
};

const chatOutput = () => {
  const chat = document.createElement("div");
  chat.className = "chat";

  websockets.client.onmessage = function (event: MessageEvent) {
    chat.appendChild(render(JSON.parse(event.data)));
  };

  return chat;
};

export default chatOutput;
