import "./style.css";
import { chatOutput, chatInput } from "./chat";

document.addEventListener("DOMContentLoaded", () => {
  const app = document.getElementById("app");

  if (app === null) {
    throw new Error("can't find app");
  }

  app.appendChild(chatOutput());
  app.appendChild(chatInput());
});
