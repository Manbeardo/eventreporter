// +build appengine

package gae

import (
	"appengine"
	"appengine/datastore"
	"appengine/search"
	"fmt"
	"net/http"

	e "github.com/Manbeardo/eventreporter"
	"github.com/Manbeardo/eventreporter/backend"
)

func init() {
	http.HandleFunc("/backend/", GaeBackendHandler)
}

func GaeBackendHandler(w http.ResponseWriter, r *http.Request) {
	backend.HandleRequest(w, r, GaeBackend{c: appengine.NewContext(r)})
}

type GaeBackend struct {
	c appengine.Context
}

func (b GaeBackend) Errorf(format string, args ...interface{}) {
	b.c.Errorf(format, args...)
}

func (b GaeBackend) get(id string, kind Kind, dst interface{}) error {
	key := datastore.NewKey(b.c, string(kind), id, 0, nil)
	err := datastore.Get(b.c, key, dst)
	if err != nil {
		return fmt.Errorf("Error fetching %v %v: %v", kind, id, err)
	} else {
		return nil
	}
}

func (b GaeBackend) put(id string, kind Kind, src interface{}) error {
	key := datastore.NewKey(b.c, string(kind), id, 0, nil)
	_, err := datastore.Put(b.c, key, src)
	if err != nil {
		return fmt.Errorf("Error putting %#v: %v", src, err)
	} else {
		return nil
	}
}

func (b GaeBackend) unusedKey(kind Kind) (*datastore.Key, error) {
	var key *datastore.Key
	for true {
		key = datastore.NewKey(b.c, KindEvent, generateKey(), 0, nil)
		if err := datastore.Get(b.c, key, nil); err == datastore.ErrNoSuchEntity {
			return key, nil
		} else if err != nil {
			return nil, err
		} else {
			// key is in use
		}
	}
	// unreachable
	panic("Very bad!")
}

type Kind string

const (
	KindPlayer Kind = "player"
	KindEvent       = "event"
	KindRound       = "round"
	KindMatch       = "match"
)

func (b GaeBackend) CreatePlayer(p e.Player) error {
	index, err := search.Open(string(KindPlayer))
	if err != nil {
		return err
	}
	remote := e.Player{}
	if err := index.Get(b.c, p.Id, &remote); err == search.ErrNoSuchDocument {
		if _, err := index.Put(b.c, p.Id, &p); err != nil {
			return fmt.Errorf("Error creating player %+v: %v", p, err)
		} else {
			return nil
		}
	} else if err != nil {
		return fmt.Errorf("Error fetching player %v: %v", p.Id, err)
	} else {
		return backend.ErrorPlayerAlreadyExists{Old: remote, New: p}
	}
}

func (b GaeBackend) SearchPlayers(query string) ([]e.Player, error) {
	index, err := search.Open(string(KindPlayer))
	if err != nil {
		return nil, err
	}
	players := []e.Player{}
	if _, err := SearchAll(index.Search(b.c, query, nil), &players); err != nil {
		return nil, err
	} else {
		return players, nil
	}
}

func (b GaeBackend) ListPlayers() ([]e.Player, error) {
	index, err := search.Open(string(KindPlayer))
	if err != nil {
		return nil, err
	}
	players := []e.Player{}
	if _, err := SearchAll(index.List(b.c, nil), &players); err != nil {
		return nil, err
	} else {
		return players, nil
	}
}

type EventEntity struct {
	ActivePlayers []e.Player
	Active        bool
	Rounds        []e.RoundId
}

func (b GaeBackend) CreateEvent() (e.EventId, error) {
	key, err := b.unusedKey(KindEvent)
	if err != nil {
		return "", err
	}
	key, err = datastore.Put(b.c, key, &EventEntity{Active: true})
	b.c.Infof("%#v", key)
	return e.EventId(key.StringID()), err
}

func (b GaeBackend) ListEvents(includeInactive bool) ([]e.EventId, error) {
	q := datastore.NewQuery(string(KindEvent))
	if !includeInactive {
		q = q.Filter("Active =", true)
	}
	if keys, err := q.GetAll(b.c, &[]EventEntity{}); err != nil {
		return nil, err
	} else {
		ids := make([]e.EventId, len(keys))
		for i, k := range keys {
			ids[i] = e.EventId(k.StringID())
		}
		return ids, nil
	}
}

func (b GaeBackend) CloseEvent(id e.EventId) error {
	event := EventEntity{}
	if err := b.get(string(id), KindEvent, &event); err != nil {
		return err
	}
	event.Active = false
	if err := b.put(string(id), KindEvent, &event); err != nil {
		return err
	}
	return nil
}
