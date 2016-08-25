package server

import (
	. "net/http"
	"strings"
	"golang.org/x/net/context"
	"golang.org/x/net/websocket"
	"regexp"
	"strconv"
)


type Service struct {
	GET			func(ResponseWriter, *Request, *context.Context)
	POST		func(ResponseWriter, *Request, *context.Context)
	PUT			func(ResponseWriter, *Request, *context.Context)
	PATCH		func(ResponseWriter, *Request, *context.Context)
	DELETE	func(ResponseWriter, *Request, *context.Context)
	HEAD		func(ResponseWriter, *Request, *context.Context)
	OPTIONS	func(ResponseWriter, *Request, *context.Context)
	UPGRADE func(*context.Context) func(*websocket.Conn)
}

func (s Service) GetHandler(r *Request) func(ResponseWriter, *Request, *context.Context) {
	switch strings.ToUpper(r.Method) {
	case "", "GET":
		if strings.ToUpper(r.Header.Get("Connection")) == "UPGRADE" {
			return func(w ResponseWriter, r *Request, c *context.Context) {
				websocket.Handler(s.UPGRADE(c)).ServeHTTP(w, r)
			}
		} else {
			return s.GET
		}
	case "POST":
		return s.POST
	case "PUT":
		return s.PUT
	case "PATCH":
		return s.PATCH
	case "DELETE":
		return s.DELETE
	case "HEAD":
		return s.HEAD
	case "OPTIONS":
		return s.OPTIONS
	default:
		return nil
	}
}



// Random utilities for services.

func (s Service) ServiceIdentically (methods []string, h func(ResponseWriter, *Request, *context.Context)) {
	// Use this procedure to apply the same RequestHandler to many http methods.
	if len(methods) == 0 {
		// An empty set of methods implies that all methods are serviced identically.
		methods = []string { "", "GET", "POST", "PUT", "PATCH", "DELETE", "HEAD", "OPTIONS" }
	}
	for _, method := range methods {
		switch strings.ToUpper(method) {
		case "", "GET":
			s.GET = h
		case "POST":
			s.POST = h
		case "PUT":
			s.PUT = h
		case "PATCH":
			s.PATCH = h
		case "DELETE":
			s.DELETE = h
		case "HEAD":
			s.HEAD = h
		case "OPTIONS":
			s.OPTIONS = h
		}
	}
}

func ReadHostname(hostnameAndPort string) string {
	match_subgrouped := regexp.MustCompile("([^:]+)(?::[1-9][0-9]+)?")
	submatches := match_subgrouped.FindStringSubmatch(hostnameAndPort)
	if len(submatches) == 0 {
		return ""
	} else {
		return submatches[1]
	}
}

func ReadImpliedPort(r *Request) int {
	if r.TLS == nil {
		return 80
	} else {
		return 443
	}
}

func ReadHostnameAndPort(r *Request) (hostname string, port int) {
	match_subgrouped := regexp.MustCompile("([^:]+)(?::([1-9][0-9]+))?")
	submatches := match_subgrouped.FindStringSubmatch(r.Host)

	if len(submatches) == 0 {
		hostname = ""
		port = ReadImpliedPort(r)

	} else if len(submatches) == 2 {
		hostname = submatches[1]
		port = ReadImpliedPort(r)

	} else { // len(submatches) == 3
		hostname = submatches[1]
		port, _ = strconv.Atoi(submatches[2])
	}

	return hostname, port
}

func ResolveHostname(r *Request, c *context.Context) string {
	// Maps "" and "localhost" to default_hostname
	hostname := ReadHostname(r.Host)
	if hostname == "localhost" || hostname == "" {
		hostname = (*c).Value("Application").(Application).Configuration.MainHost
	}
	return hostname
}