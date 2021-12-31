export type AckMessage = {
  type: "ack";
  message: string;
};

export type ChatMessage = {
  type: "msg";
  message: string;
};

export type IncomingMessage = AckMessage | ChatMessage;

export type TypedMessage = {
  type: "message";
  message: string;
};

export type OutgoingMessage = TypedMessage;
