package main

import (
	"flag"
	"log"
	"net/url"

	"github.com/gorilla/websocket"
)

var addr = flag.String("addr", "echo.websocket.org", "http service address")

func main() {
	flag.Parse()
	log.SetFlags(0)

	u := url.URL{Scheme: "ws", Host: *addr, Path: "/"}
	log.Printf("connecting to %s", u.String())

	c, _, err := websocket.DefaultDialer.Dial(u.String(), nil)
	if err != nil {
		log.Fatal("dial:", err)
	}

	openViewer(c)
}
