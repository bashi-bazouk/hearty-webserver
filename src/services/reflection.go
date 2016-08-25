package services

import (
	. "server"
	. "net/http"
	"golang.org/x/net/context"
	"encoding/json"
)

type ReflectionData struct {
	ObservedAddress string
	Header Header
}

var Reflection Service = Service {
	GET: func(w ResponseWriter, r *Request, c *context.Context) {

		reflectionData := ReflectionData {
			ObservedAddress: (*r).RemoteAddr,
			Header: (*r).Header,
		}

		str, _ := json.MarshalIndent(reflectionData, "", "\t")
		w.Write([]byte(str))
	},
}