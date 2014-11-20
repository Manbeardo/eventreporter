package frontend

import (
	"fmt"
	"io"
	"net/http"
	"os"
	"strings"

	e "github.com/Manbeardo/eventreporter"
)

type PagePath string

const (
	PagePlayers PagePath = "/players"
)

func HandleRequest(w http.ResponseWriter, r *http.Request, l e.Logger) {
	path := strings.TrimPrefix(r.URL.Path, "/frontend")
	switch PagePath(path) {
	case PagePlayers: // static pages
		if html, err := os.Open(fmt.Sprintf("static/html%v.html", path)); err != nil {
			e.WriteError(w, l, http.StatusInternalServerError, err)
		} else {
			io.Copy(w, html)
		}
	default:
		w.WriteHeader(http.StatusNotFound)
		w.Write([]byte(fmt.Sprintf("404: %v is not a recognized method", r.URL.Path)))
	}
}
