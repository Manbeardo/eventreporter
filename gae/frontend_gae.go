// +build appengine

package gae

import (
	"appengine"
	"github.com/Manbeardo/eventreporter/frontend"
	"net/http"
)

func init() {
	http.HandleFunc("/frontend/", GaeFrontend)
}

func GaeFrontend(w http.ResponseWriter, r *http.Request) {
	c := appengine.NewContext(r)
	frontend.HandleRequest(w, r, c)
}
