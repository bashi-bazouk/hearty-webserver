package services

import (
	. "net/http"
	. "server"
	"golang.org/x/net/context"
	"go/types"
	"encoding/json"
)

func Collection(t types.Type) Service {
	var jsonStore *json.RawMessage
	json.Unmarshal([]byte("{ }"), jsonStore)

	validate := func (json []byte) bool {
		return true
	}
	validate(nil)

	return Service {

		GET: func(w ResponseWriter, r *Request, c *context.Context) {

		},

		POST: func(w ResponseWriter, r *Request, c *context.Context) {

		},

		PUT: func(w ResponseWriter, r *Request, c *context.Context) {

		},

		DELETE: func(w ResponseWriter, r *Request, c *context.Context) {

		},

		PATCH: func(w ResponseWriter, r *Request, c *context.Context) {

		},

	}
}