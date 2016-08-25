package server


import (
	. "net/http"
	"time"
	"log"
	"os"
	"strconv"
	"utilities"
	"golang.org/x/net/context"
	"fmt"
	"runtime"
)


// Application Settings
type KeySettings struct {
		 SelfSign bool
		 CertFile string
		 KeyFile  string
		 CSR      utilities.CertificateSigningRequest }

type PortSettings map[Protocol][]int

type ApplicationSettings struct {
	Keys            KeySettings
	Ports           PortSettings
	StaticDirectory string
	MainHost        string
}


// Application

type Application struct {
	Configuration   ApplicationSettings
	Router          Router
	compiledRouter  *CompiledRouter
	compiledContext *context.Context
}


func NewApplication(configuration ApplicationSettings, router Router) (ws Application) {
	ws.Configuration = configuration
	ws.Router = router

	compiledContext := context.WithValue(context.Background(), "Application", ws)
	ws.compiledContext = &compiledContext

	var compiledRouter = make(CompiledRouter)
	for protocol, hosts := range router {
		var routesByHost = make(map[Hostname] []CompiledRoute)
		for host, routes := range hosts {
			for _, route := range routes {
				routesByHost[host] = append(routesByHost[host], route.Compile())
			}
		}
		compiledRouter[protocol] = routesByHost
	}

	ws.compiledRouter = &compiledRouter

	return ws
}


func (ws Application) EnsureCertificates () {
	var keySettings = ws.Configuration.Keys

	var _, maybeCertError = os.Stat(keySettings.CertFile)
	var _, maybeKeyError = os.Stat(keySettings.KeyFile)

	if os.IsNotExist(maybeCertError) || os.IsNotExist(maybeKeyError) {
		// Certificate or Key is missing.
		println(fmt.Sprintf("Missing one of (%s, %s).", keySettings.CertFile, keySettings.KeyFile))
		if keySettings.SelfSign {
			println("Auto-generating...")
			utilities.Sign(keySettings.CSR, keySettings.CertFile, keySettings.KeyFile)
			println("Done.")
		} else {
			log.Fatal("Missing Certificates.")
		}
	}
}


func (ws Application) ServeHTTP(w ResponseWriter, r *Request) {

	var protocol Protocol
	if r.TLS != nil {
		protocol = HTTPS
	} else {
		protocol = HTTP
	}

	hostname := ReadHostname(r.Host)
	if hostname == "localhost" {
		hostname = ws.Configuration.MainHost
	}

	println("?", r.URL.String())
	for _, route := range (*ws.compiledRouter)[protocol][Hostname(hostname)] {
		subgroups := route.Pattern.FindStringSubmatch(r.URL.Path)
		if subgroups != nil {
			context := context.WithValue(*ws.compiledContext, "groups", subgroups)
			handler := route.Service.GetHandler(r)
			handler(w, r, &context)
			return
		}
	}

	println("!", r.URL.String(), "404 Not Found")
	Error(w, "404 Not Found", 404)

}

func (ws Application) SetParallelism () {

	cpuCount := runtime.NumCPU()
	configuration := ws.Configuration
	endpoints := len(configuration.Ports[HTTP]) + len(configuration.Ports[HTTPS])

	if cpuCount < endpoints {
		log.Printf(fmt.Sprintln(
			"CPU count, %i, is less than the number of endpoints, %i. " +
			"Non-Uniform polling behavior may occur.", cpuCount, endpoints))
	}

	runtime.GOMAXPROCS(cpuCount)
}

func (ws Application) LaunchPeers () {

	var configuration = ws.Configuration
	var hostname = ws.Configuration.MainHost

	httpPortCount := len(ws.Configuration.Ports[HTTP])

	ports := append(ws.Configuration.Ports[HTTP], ws.Configuration.Ports[HTTPS]...)
	portCount := len(ports)

	for i, Port := range ports {
		port := Port
		var launcher func()
		if i < httpPortCount {
			launcher = func() {
				var httpServer = &Server {
					Addr:           ":" + strconv.Itoa(port),
					Handler:        ws,
					ReadTimeout:    10 * time.Second,
					WriteTimeout:   10 * time.Second,
					MaxHeaderBytes: 1 << 20,
				}
				log.Printf("Launching Low-Ground Peer at http://%s:%d.", hostname, port)
				httpServer.ListenAndServe()
			}
		} else {
			launcher = func() {
				var httpsServer = &Server {
					Addr:           ":" + strconv.Itoa(port),
					Handler:        ws,
					ReadTimeout:    10 * time.Second,
					WriteTimeout:   10 * time.Second,
					MaxHeaderBytes: 1 << 20,
				}
				log.Printf("Launching High-Ground Peer at https://%s:%d.", hostname, port)
				httpsServer.ListenAndServeTLS(configuration.Keys.CertFile, configuration.Keys.KeyFile)
			}
		}

		if i != portCount - 1 {
			go launcher()
		} else {
			launcher()
		}
	}

}


func (ws Application) Run() {
	ws.EnsureCertificates()
	ws.SetParallelism()
	ws.LaunchPeers()
	//localPeers := ws.LaunchPeers()

}