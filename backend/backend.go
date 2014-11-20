package backend

import (
	"fmt"
	"net/http"
	"strings"

	e "github.com/Manbeardo/eventreporter"
)

type Backend interface {
	CreatePlayer(p e.Player) error
	ListPlayers() ([]e.Player, error)
	SearchPlayers(search string) ([]e.Player, error)
	CreateEvent() (e.EventId, error)
	CloseEvent(id e.EventId) error
	// AddPlayerToEvent(id EventId, p Player) error
	// DropPlayerFromEvent(id EventId, p Player)
	ListEvents(includeInactive bool) ([]e.EventId, error)
	// GetEvent(id EventId) (Event, error)
	// SubmitRound(id EventId, n int, r Round) ([]MatchId, error)
	// UpdateMatch(id MatchId, m Match) error

	Errorf(format string, args ...interface{})
}

type MethodPath string

const (
	MethodCreatePlayer  MethodPath = "/players/create"
	MethodListPlayers              = "/players/list"
	MethodSearchPlayers            = "/players/search"
	MethodCreateEvent              = "/events/create"
	MethodListEvents               = "/events/list"
)

func HandleRequest(w http.ResponseWriter, r *http.Request, b Backend) {
	switch MethodPath(strings.TrimPrefix(r.URL.Path, "/backend")) {
	case MethodCreatePlayer:
		p := e.Player{}
		if ok := e.LoadAndValidate(w, r, b, &p); !ok {
			return
		}
		if err := e.WriteError(w, b, http.StatusInternalServerError, b.CreatePlayer(p)); err != nil {
			return
		}
		e.WriteJson(w, &[]e.Player{p})
	case MethodListPlayers:
		if players, err := b.ListPlayers(); err != nil {
			e.WriteError(w, b, http.StatusInternalServerError, err)
		} else {
			e.WriteJson(w, players)
		}
	case MethodSearchPlayers:
		p := struct {
			Query string `checks:"NotEmpty"`
		}{}
		if ok := e.LoadAndValidate(w, r, b, &p); !ok {
			return
		} else if players, err := b.SearchPlayers(p.Query); err != nil {
			e.WriteError(w, b, http.StatusInternalServerError, err)
		} else {
			e.WriteJson(w, players)
		}
	case MethodCreateEvent:
		if id, err := b.CreateEvent(); err != nil {
			e.WriteError(w, b, http.StatusInternalServerError, err)
			return
		} else {
			w.Write([]byte(id))
		}
	case MethodListEvents:
		p := struct{ IncludeInactive bool }{}
		if ok := e.LoadAndValidate(w, r, b, &p); !ok {
			return
		}
		if events, err := b.ListEvents(p.IncludeInactive); err != nil {
			e.WriteError(w, b, http.StatusInternalServerError, err)
		} else {
			e.WriteJson(w, events)
		}
	default:
		w.WriteHeader(http.StatusNotFound)
		w.Write([]byte(fmt.Sprintf("404: %v is not a recognized method", r.URL.Path)))
	}
}
