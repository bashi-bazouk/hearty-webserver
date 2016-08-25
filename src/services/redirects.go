package services

import (
	. "server"
	"net/http"
	"golang.org/x/net/context"
	"strconv"
	"path"
	"utilities"
	"math/rand"
)

func HandleUpgradeToHTTPS(w http.ResponseWriter, r *http.Request, c *context.Context) {
	url := r.URL
	url.Scheme = "https"

	httpsPorts, _ := (*c).Value("Application").(Application).Configuration.Ports[HTTPS]
	if len(httpsPorts) > 0 {
		url.Host = ReadHostname(r.Host) + ":" + strconv.Itoa(rand.Intn(len(httpsPorts)))
	} else {
		http.NotFound(w, r)
	}

	http.Redirect(w, r, url.String(), 301)
}


var UpgradeToHTTPS = Service {
	GET: HandleUpgradeToHTTPS,
	POST: HandleUpgradeToHTTPS,
	PUT: HandleUpgradeToHTTPS,
	PATCH: HandleUpgradeToHTTPS,
	DELETE: HandleUpgradeToHTTPS,
	HEAD: HandleUpgradeToHTTPS,
	OPTIONS: HandleUpgradeToHTTPS,
}


func Link(pathFromRoot string) Service {
	fullPath := path.Join(utilities.Root, pathFromRoot)
	return Service {
		GET: func(w http.ResponseWriter, r *http.Request, c *context.Context) {
			http.ServeFile(w, r, fullPath)
		},
	}
}


func ServeClient (clientName string) Service {
	return Link(path.Join("src/clients", clientName + ".js"))
}