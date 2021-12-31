import { log } from "./log";
import { IncomingMessage } from "./types";
import { client, sendMessage } from "./websockets";

const renderMessage = ({ message }: IncomingMessage) => {
  const messageElement = document.createElement("div");
  messageElement.className = "message";
  messageElement.innerText = `Mitch: ${message}`;
  return messageElement;
};

const elementForMessage = (message: IncomingMessage) => {
  switch (message.type) {
    case "ack": // a message you've sent yourself coming back to you
      return renderMessage(message);
    case "msg": // generic messages from other users / entities
      return renderMessage(message);
    default:
      throw new Error(`Unknown message type`);
  }
};

export const chatOutput = () => {
  const chat = document.createElement("div");
  chat.className = "chat";

  client.onmessage = (event: MessageEvent) => {
    const incomingMessage = JSON.parse(event.data) as IncomingMessage;
    log("Incoming message", incomingMessage);
    const element = elementForMessage(incomingMessage);
    chat.appendChild(element);
  };

  return chat;
};

export const chatInput = () => {
  const input = document.createElement("input");
  input.type = "text";
  input.placeholder = "Type your message here...";
  input.className = "chat-input";
  input.id = "chat-box";

  input.addEventListener("keyup", (e) => {
    if (e.key === "Enter") {
      const message = input.value;
      input.value = "";
      sendMessage(message);
    }
  });

  return input;
};
