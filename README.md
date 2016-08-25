

## Getting Started

In the shell:
```
git clone https://github.com/bashi-bazouk/hearty-webserver.git;
cd hearty-webserver;
./run-dev.sh
```

Beginner's note: If `run-dev.sh` does not have executable privileges, you can grant
them from the shell by typing `sudo chmod +x ./run-dev.sh`.


## How Hearty Works

There are three logical starting points for Hearty, corresponding to the files:

- `src/configuration/application.go`
- `src/configuration/router.go`, and
- `src/main.go`

The configuration files are human-readable. They are valid go data-structures, 
so you, as a developer, may freely adapt them with your own configuration logic.

In the `main` method of the `src/main.go` file, you will find the first steps of
the program. Amongst these commands is the imperative:

```
NewApplication(Settings[DEVELOPMENT], ApplicationRouter).Run()
```

What this does is,
1) look up the development settings in `src/configuration/application.go`,
2) look up the web-service router in `src/configuration/router.go`,
3) instantiate a new `Application` object with the given settings and router, and
4) launch the new `Application` by calling `Run`.


## Customizing Hearty

### Some Background

I wrote Hearty to aggregate a set of tricks I've learned in Python and other
languages. You'll notice that the initial download comes configured to run my
personal website, <brianledger.net>. This is because a) I use Hearty in my own
production scenario, b) I felt it would be more instructive for a user to see 
a fully featured project, and c) The references are very obvious, and suggest 
locations for the user to override.


### The Router

The Router is so named because it routes requests. The Router is the most 
frequently edited and referenced file in the web-server.

Let's look at an example router.

```
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
```

Observe that the Router looks much like a Table of Contents. In fact, it is
even more structured. The Router shows us a decision procedure, that checks

a) Is the request protocol secure or insecure?
b) What host was requested?
c) What was the path in the URL?

At the innermost elements, we see what *kind* of handler our request will be
routed to. This is convenient if you have an IDE that can click-through-to-code.

#### ServeStatic

Let's say you're developing a new website, <devonshireyaw.com>. You'll want
to install a route for the new page, so that you can serve arbitrary files
to the user. We'll augment the `HTTP` routes to add a static file service.

```
var ApplicationRouter = Router {
	HTTP: map[Hostname] []Route {
		"brianledger.net": []Route {
			{ "/(.*)", UpgradeToHTTPS, },
		},
		"devonshireyaw.com": []Route {
			{ "/(.*)", ServeStatic, },
		},
	},
	...
}
```

In production, when people send a request to 
<http://devonshireyaw.com/index.html>, the file `index.html` will be given
to them from the folder `/src/static/devonshireyaw.com/`.

#### Changing the primary host.

When developing locally, it's easy to request `localhost:8080` in Chrome, 
to see how your project appears in the browser. When Hearty receives a 
request for the site `localhost`, it substitutes a default hostname given
in the Application Settings. You can find the `MainHost` field in
`src/configuration/application.go`.

```
var Settings = map[Environment]ApplicationSettings{

	DEVELOPMENT: {
		MainHost: "brianledger.net",
		...
	},
	...
```

#### Certificates

In order to run `HTTPS` servers on the web, you must procure an SSL Certificate
from a Certificate Signing Authority. This is a third party that, for the benefit
of security, will distribute a key on your behalf, for use in public-key encryption.

In local development, developers can use a "self-signed certificate" to create and 
test HTTPS connections on their local machines. By editing the `Keys` KeySettings in
the configuration, Hearty will automatically generate this certificate for you.

Ex.
```
var Settings = map[Environment]ApplicationSettings{

	DEVELOPMENT: {
		...

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
		...
	},
```

## Custom Clients

The `src/clients` folder contains a fully featured personal website. The project is written in CoffeeScript,
and compiled with Webpack.


## Common Warnings

If you see the warning:

> CPU count, m, is less than the number of endpoints, n. Non-Uniform polling behavior may occur.

you may have a computer with less CPUs than the number of Ports you are configured to service. Go
to your `src/configuration/application.go` file and edit the `Ports` field of your target configuration.
This warning disappears when there are sufficient CPUs to service all of the designated ports.

