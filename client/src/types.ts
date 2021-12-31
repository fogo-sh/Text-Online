export const MESSAGE_TYPES = {
  INT: "int",
  ACK: "ack",
  MSG: "msg",
  MESSAGE: "message",
};

export type Message<Type> = {
  type: Type;
  message: string;
};

export type AnyMessage = Message<string>;

export type InternalMessage = Message<"int">;

export type AckMessage = Message<"ack">;
export type ChatMessage = Message<"msg">;
export type IncomingMessage = AckMessage | ChatMessage;

export type TypedMessage = Message<"message">;
export type OutgoingMessage = TypedMessage;
