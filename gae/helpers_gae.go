// +build appengine

package gae

import (
	"appengine/search"
	"crypto/rand"
	"encoding/base64"
	"reflect"
)

func generateKey() string {
	b := make([]byte, 6)
	rand.Read(b)
	return base64.URLEncoding.EncodeToString(b)
}

func SearchAll(i *search.Iterator, dst interface{}) ([]string, error) {
	rdst := reflect.ValueOf(dst)
	if rdst.Type().Kind() != reflect.Ptr {
		panic("dst must be a pointer")
	} else if rdst.Type().Elem().Kind() != reflect.Slice {
		panic("dst must point to a slice")
	} else if rdst.Type().Elem().Elem().Kind() != reflect.Struct {
		panic("dst must point to a slice of structs")
	} else if reflect.Indirect(rdst).Len() != 0 {
		panic("dst must be empty")
	}
	keys := []string{}
	for true {
		elem := reflect.New(rdst.Type().Elem().Elem())
		if key, err := i.Next(elem.Interface()); err == search.Done {
			break
		} else if err != nil {
			return nil, err
		} else {
			keys = append(keys, key)
			rdst.Elem().Set(reflect.Append(rdst.Elem(), elem.Elem()))
		}
	}
	return keys, nil
}
