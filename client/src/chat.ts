import { log } from "./log";
import { AnyMessage, IncomingMessage, MESSAGE_TYPES } from "./types";
import { client, sendMessage } from "./websockets";

const renderMessage = (
  { message }: AnyMessage,
  customClasses: string[] = []
) => {
  const messageElement = document.createElement("div");
  messageElement.classList.add(...["message", ...customClasses]);
  messageElement.innerText = message;
  return messageElement;
};

const elementForMessage = (message: AnyMessage) => {
  switch (message.type) {
    case MESSAGE_TYPES.ACK: // a message you've sent yourself coming back to you
      return renderMessage(message);
    case MESSAGE_TYPES.MSG: // generic messages from other users / entities
      return renderMessage(message);
    case MESSAGE_TYPES.INT: // an internal message generated clientside
      return renderMessage(message, ["message-internal"]);
    default:
      throw new Error(`Unknown message type: ${message.type}`);
  }
};

export const chatOutput = () => {
  const chat = document.createElement("div");
  chat.className = "chat";

  const displayMessage = (message: AnyMessage) => {
    const element = elementForMessage(message);
    chat.prepend(element);
  };

  const displayInternalMessage = (message: string) =>
    displayMessage({ type: MESSAGE_TYPES.INT, message });

  displayInternalMessage("Connecting to Text Online...");

  client.onopen = () => displayInternalMessage("Connected to Text Online!");
  client.onclose = () =>
    displayInternalMessage("Disconnected from Text Online");

  client.onmessage = (event: MessageEvent) => {
    const incomingMessage = JSON.parse(event.data) as IncomingMessage;
    log("Incoming message", incomingMessage);
    displayMessage(incomingMessage);
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
