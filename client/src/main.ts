import "./style.css";
import { chatInput } from "./components";
import chatOutput from "./chat";

document.addEventListener("DOMContentLoaded", function () {
  const app = document.getElementById("app");

  if (app === null) {
    throw new Error("can't find app");
  }

  app.appendChild(chatOutput());
  app.appendChild(chatInput());
});
