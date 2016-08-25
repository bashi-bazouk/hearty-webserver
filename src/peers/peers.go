package cluster

import (
	. "net/http"
	. "net/url"
)

// Peers have a concrete equality, and an abstract notion of interaction.

type FreePeer struct {
	ID func() interface{}
	Relate func(D Request, C *Response) error
}

type Peer interface {
	ID() interface{}
	Relate(D Request, C *Response) error
}

func (p0 Peer) Equals (p1 Peer) bool {
	return p0.ID() == p1.ID()
}


type RemotePeer URL

func (ID RemotePeer) ID () interface{} { return ID }

func (ID RemotePeer) Relate (D Request, C *Response) error {
	D.URL = ID
	remoteResponse, err := DefaultTransport.RoundTrip(D)
	*C = *remoteResponse
	return err
}