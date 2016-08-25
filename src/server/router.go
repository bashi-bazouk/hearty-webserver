package server

import (
	"regexp"
	"strings"
	"fmt"
)

type Protocol int
const (
	HTTP Protocol = iota
	HTTPS
)

func (p Protocol) String () string {
	switch p {
	case HTTP: return "HTTP"
	case HTTPS: return "HTTPS"
	default: panic("Invalid Protocol")
	}
}

func ReadProtocol (s string) Protocol {
	switch strings.ToUpper(s) {
	case "HTTP": return HTTP
	case "HTTPS": return HTTPS
	default:
		panic(fmt.Sprintf("Invalid Protocol string: \"%s\"", s))
	}
}

type Hostname string

type Pattern string

type Route struct {
	Pattern string
	Service Service
}

type Router map[Protocol]map[Hostname] []Route

type CompiledRoute struct {
	Pattern *regexp.Regexp
	Service Service
}

func (r Route) Compile () CompiledRoute {
	return CompiledRoute {
		Pattern: regexp.MustCompile(r.Pattern),
		Service: r.Service,
	}
}

type CompiledRouter map[Protocol]map[Hostname] []CompiledRoute