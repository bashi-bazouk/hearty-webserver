package configuration

import (
	"utilities"
	. "server"
)

// Environment = Development | Production
type Environment int
const (
	DEVELOPMENT Environment = iota
	PRODUCTION
)


var Settings = map[Environment]ApplicationSettings{

	DEVELOPMENT: {
		MainHost: "brianledger.net",
		StaticDirectory: "src/static",

		Keys: KeySettings {
			SelfSign: true,
			CertFile: "dev-cert.pem",
			KeyFile: "dev-key.pem",

			CSR: utilities.CertificateSigningRequest {
				Host:      "brianledger.net,softarc.net",
				ValidFrom: "Jan 8 00:00:00 1988",
				ValidFor:  1 << 20,
				IsCA:      true,
				RSABits:   4096,
			},
		},

		Ports: PortSettings {
			HTTP: []int { 8080 },
			HTTPS: []int { 4430, 4431, 4432 },
		},
	},



	PRODUCTION: {
		MainHost: "brianledger.net",
		StaticDirectory: "src/static",

		Keys: KeySettings {
			SelfSign: false,
			CertFile: "cert.pem",
			KeyFile: "key.pem",
		},

		Ports: PortSettings {
			HTTP: []int { 80 },
			HTTPS: []int { 443 },
		},
	},

}