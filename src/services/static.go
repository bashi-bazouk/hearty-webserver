package services

import (
	. "server"
	. "net/http"
	"golang.org/x/net/context"
	"path"
	"os"
)

var ServeStatic Service = func() Service {
	doServeStatic := func (w ResponseWriter, r *Request, c *context.Context) {
		staticFolder := (*c).Value("Application").(Application).Configuration.StaticDirectory
		hostname := ResolveHostname(r, c)
		requestPath := (*c).Value("groups").([]string)[1]
		workingDirectory, _ := os.Getwd()
		fullPath := path.Join(workingDirectory, staticFolder, hostname, requestPath)
		ServeFile(w, r, fullPath)
	}
	return Service {
		GET: doServeStatic,
		HEAD: doServeStatic,
	}
}()