package eventreporter

import (
	"encoding/json"
	"fmt"
	"github.com/Manbeardo/structcheck"
	"github.com/gorilla/schema"
	"net/http"
)

type Logger interface {
	Errorf(fmt string, args ...interface{})
}

func LoadAndValidate(w http.ResponseWriter, r *http.Request, l Logger, dst interface{}) (ok bool) {
	r.ParseForm()
	if err := schema.NewDecoder().Decode(dst, r.Form); err != nil {
		err = fmt.Errorf("Error parsing form values: %v", err)
		WriteError(w, l, http.StatusInternalServerError, err)
		return false
	}
	if err := structcheck.Validate(dst); err != nil {
		err = fmt.Errorf("Error validating form values: %v", err)
		WriteError(w, l, http.StatusInternalServerError, err)
		return false
	}
	return true
}

func WriteError(w http.ResponseWriter, l Logger, status int, err error) error {
	if err == nil {
		return nil
	}
	l.Errorf("%v", err)
	w.WriteHeader(status)
	w.Write([]byte(err.Error()))
	return err
}

func WriteJson(w http.ResponseWriter, i interface{}) error {
	w.Header().Set("Content-Type", "application/json")
	return json.NewEncoder(w).Encode(i)
}
