package main

// An example program demonstrating the pager component from the Bubbles
// component library.

import (
	"fmt"
	"log"
	"os"
	"strings"

	"github.com/charmbracelet/bubbles/textinput"
	"github.com/charmbracelet/bubbles/viewport"
	tea "github.com/charmbracelet/bubbletea"
	"github.com/gorilla/websocket"
	"github.com/mattn/go-runewidth"
	"github.com/muesli/reflow/wordwrap"
)

const (
	// You generally won't need this unless you're processing stuff with some
	// pretty complicated ANSI escape sequences. Turn it on if you notice
	// flickering.
	//
	// Also note that high performance rendering only works for programs that
	// use the full size of the terminal. We're enabling that below with
	// tea.EnterAltScreen().
	useHighPerformanceRenderer = false

	headerHeight = 3
	footerHeight = 1
)

func openViewer(conn *websocket.Conn) {
	path := os.Getenv("PAGER_LOG")
	if path != "" {
		f, err := tea.LogToFile(path, "pager")
		if err != nil {
			fmt.Printf("Could not open file %s: %v", path, err)
			os.Exit(1)
		}
		defer f.Close()
	}

	p := tea.NewProgram(
		initialModel(conn, string("Welcome")),
		tea.WithAltScreen(),
		tea.WithMouseCellMotion(),
	)

	if err := p.Start(); err != nil {
		log.Println("could not run program:", err)
		os.Exit(1)
	}
}

type model struct {
	c         *websocket.Conn
	sub       chan string
	content   string
	ready     bool
	viewport  viewport.Model
	textInput textinput.Model
	err       error
}

func initialModel(c *websocket.Conn, content string) model {
	ti := textinput.NewModel()
	ti.Placeholder = "Type a message..."
	ti.Focus()
	ti.CharLimit = 156
	ti.Width = 20

	return model{
		sub:       make(chan string),
		c:         c,
		content:   content,
		textInput: ti,
		err:       nil,
	}
}

func (m model) Init() tea.Cmd {
	return tea.Batch(
		textinput.Blink,
		listenForMessages(m.c, m.sub),
		waitForMessages(m.sub),
	)
}

func (m model) Update(msg tea.Msg) (tea.Model, tea.Cmd) {
	var (
		cmd  tea.Cmd
		cmds []tea.Cmd
	)

	switch msg := msg.(type) {
	case tea.KeyMsg:
		switch msg.Type {
		case tea.KeyTab:
			if m.textInput.Focused() {
				m.textInput.Blur()
			} else {
				m.textInput.Focus()
			}
		case tea.KeyEnter:
			err := m.c.WriteMessage(websocket.TextMessage, []byte(m.textInput.Value()))
			if err != nil {
				log.Println("write:", err)
				return m, tea.Quit
			}
			m.textInput.SetValue("")
		case tea.KeyCtrlC, tea.KeyEsc:
			return m, tea.Quit
		}

	case tea.WindowSizeMsg:
		verticalMargins := headerHeight + footerHeight

		if !m.ready {
			// Since this program is using the full size of the viewport we need
			// to wait until we've received the window dimensions before we
			// can initialize the viewport. The initial dimensions come in
			// quickly, though asynchronously, which is why we wait for them
			// here.
			m.viewport = viewport.Model{Width: msg.Width, Height: msg.Height - verticalMargins}
			m.viewport.YPosition = headerHeight
			m.viewport.HighPerformanceRendering = useHighPerformanceRenderer
			m.ready = true
		} else {
			m.viewport.Width = msg.Width
			m.viewport.Height = msg.Height - verticalMargins
		}

		cutoff := wordwrap.String(m.content, m.viewport.Width)
		m.viewport.SetContent(cutoff)
		m.textInput.Width = m.viewport.Width

		if useHighPerformanceRenderer {
			// Render (or re-render) the whole viewport. Necessary both to
			// initialize the viewport and when the window is resized.
			//
			// This is needed for high-performance rendering only.
			cmds = append(cmds, viewport.Sync(m.viewport))
		}
	case newMsg:
		m.content = m.content + "\n" + msg.message
		cutoff := wordwrap.String(m.content, m.viewport.Width)
		m.viewport.SetContent(cutoff)
		return m, waitForMessages(m.sub)
	}

	m.textInput, cmd = m.textInput.Update(msg)
	cmds = append(cmds, cmd)

	if !m.textInput.Focused() {
		m.viewport, cmd = m.viewport.Update(msg)
		cmds = append(cmds, cmd)
	}

	if useHighPerformanceRenderer {
		cmds = append(cmds, cmd)
	}

	return m, tea.Batch(cmds...)
}

func (m model) View() string {
	if !m.ready {
		return "\n  Initializing..."
	}

	headerTop := "╭─────────────╮"
	headerMid := "│ text-online ├"
	headerBot := "╰─────────────╯"
	headerMid += strings.Repeat("─", m.viewport.Width-runewidth.StringWidth(headerMid))
	header := fmt.Sprintf("%s\n%s\n%s", headerTop, headerMid, headerBot)

	return fmt.Sprintf("%s\n%s\n%s", header, m.viewport.View(), m.textInput.View())
}
