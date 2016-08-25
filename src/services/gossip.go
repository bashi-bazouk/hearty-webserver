package services

import (
	. "regexp"
	. "server"
	. "net/http"
	"golang.org/x/net/context"
	"golang.org/x/net/websocket"
	"fmt"
	"net/url"
	"sync"
	"encoding/json"
)

type Gossip *Regexp

var (
	SubjectiveAgentIsOffline Gossip = MustCompile("(\\S+) is dead.")
	SubjectiveAgentIsOnline = MustCompile("(\\S+) is undead.")
	ObjectiveAgentIsOffline = MustCompile("(\\S+) says (\\S+) is dead.")
	ObjectiveAgentIsOnline = MustCompile("(\\S+) says (\\S+) is undead.")
)

type PeerGossip struct {
	Peers map[url.URL] interface {
		ID() interface{}
		Relate(D Request, C *Response) error
	}
	Gossip []string
	Mutex sync.RWMutex
}

var Global *PeerGossip = &PeerGossip {
	Peers: *new(map[url.URL] interface {
		ID() interface{}
		Relate(D Request, C *Response) error
	}),
	Gossip: []string { "BelaLugosi is dead."},
}

func (pg PeerGossip) ToJSON () []byte {
	pg.Mutex.RLock()							// Begin Critical Section

	len_gossip := len(pg.Gossip)
	allGossip := make([]string, 0, len_gossip + len(pg.Peers))
	allGossip = pg.Gossip

	counter := 0
	for Url, _ := range pg.Peers {
		allGossip[len_gossip+counter] = fmt.Sprintf("%s is undead.", Url.String())
		counter++
	}

	pg.Mutex.RUnlock()						// End Critical Section

	json, _ := json.MarshalIndent(allGossip, "", "\t")
	return json
}

var GossipService Service = Service {
	GET: func(w ResponseWriter, r *Request, c *context.Context) {
		w.Write(Global.ToJSON())
	},

	POST: func(w ResponseWriter, r *Request, c *context.Context) {

	},

	PUT: func(w ResponseWriter, r *Request, c *context.Context) {

	},

	DELETE: func(w ResponseWriter, r *Request, c *context.Context) {

	},

	UPGRADE: func(c *context.Context) func(*websocket.Conn) {
		return func(conn *websocket.Conn) {
			println("Holy shit it worked.")
			fmt.Printf("RemoteAddr: %s\n", conn.RemoteAddr())
			fmt.Printf("LocalAddr: %s\n", conn.LocalAddr())
			fmt.Printf("IsClientConn: %t\n", conn.IsClientConn())
			fmt.Printf("IsServerConn: %t\n", conn.IsServerConn())
			conn.Write(Global.ToJSON())
		}
	},
}