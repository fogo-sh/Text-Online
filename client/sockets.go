package main

import (
	"log"

	tea "github.com/charmbracelet/bubbletea"
	"github.com/gorilla/websocket"
)

type newMsg struct{ message string }

type errMsg struct{ err error }

func listenForMessages(conn *websocket.Conn, sub chan string) tea.Cmd {
	return func() tea.Msg {
		for {
			_, message, err := conn.ReadMessage()
			if err != nil {
				log.Println("read:", err)
				return errMsg{err}
			}
			log.Println("recieved message, sending to channel:", string(message))
			sub <- string(message)
		}
	}
}

func waitForMessages(sub chan string) tea.Cmd {
	return func() tea.Msg {
		return newMsg{message: <-sub}
	}
}
