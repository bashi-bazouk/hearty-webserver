{ SubApplication } = require("../../framework/SubApplication.coffee")

window.api ?= { }
api['gossip'] = () ->
	get: () ->
		new Promise (resolve, reject) ->
			$.getJSON "/gossip/", null, resolve
	connect: () ->
		new Promise (resolve, reject) ->
			ws = new WebSocket("wss://" + window.location.host + "/gossip/", [])
			ws.onopen = () -> resolve(ws)

class exports.PeerGraph extends SubApplication

	constructor: () ->
		@pure = $("""<div class="peer-graph">SEED DATA</div>""")

		api.gossip().get().then (gossip) =>
			@pure.text(gossip)

		api.gossip().connect().then (gossip_channel) =>
			console.log("Fwaaaa!", gossip_channel)


	open: (callback) ->
		callback?()

	close: (callback) ->
		callback?()

