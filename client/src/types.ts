export type AckMessage = {
  type: "ack";
  message: string;
};

export type IncomingMessage = AckMessage;

export type TypedMessage = {
  type: "message";
  message: string;
};

export type OutgoingMessage = TypedMessage;
