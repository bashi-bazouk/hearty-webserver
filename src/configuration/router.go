package configuration

import (
	. "server"
	. "services"
)

var ApplicationRouter = Router {
	HTTP: map[Hostname] []Route {
		"brianledger.net": []Route {
			{ "/(.*)", UpgradeToHTTPS, },
		},
	},
	HTTPS: map[Hostname] []Route {
		"brianledger.net": []Route {
			{ "/client.js", ServeClient("brianledger_public"), },
			{ "/reflect", Reflection },
			{ "/gossip/", GossipService },
			{ "/cdn/(.*)", ServeStatic, },
			{ "/(.*)", ServeStatic, },
		},
	},
}

