import websockets from "./websockets";

export const chatInput = () => {
  const input = document.createElement("input");
  input.type = "text";
  input.placeholder = "Type your message here...";
  input.className = "chat-input";
  input.id = "chat-box";
  console.log(input);
  input.addEventListener("keyup", (e) => {
    if (e.key === "Enter") {
      const message = input.value;
      input.value = "";
      websockets.sendMessage(message);
    }
  });
  return input;
};
