
{ SubApplication } = require("./framework/SubApplication.coffee")
{ Information } = require("./subapplications/Information.coffee")
{ TechnicalWriting } = require("./subapplications/technical_writing/TechnicalWriting.coffee")
{ MessageBoard } = require("./subapplications/message_board/MessageBoard.coffee")
{ Resume } = require("./subapplications/Resume.coffee")
{ Authenticator } = require("./subapplications/authenticator/Authenticator.coffee")
{ PeerGraph } = require("./subapplications/peer_graph/PeerGraph.coffee")

class exports.Application extends SubApplication

	routes:
		'': "stop"
		':route/': "default_navigation"

	subapplications:
		information: Information
		technical_writing: TechnicalWriting
		message_board: MessageBoard
		resume: Resume
		authenticator: Authenticator
		peer_graph: PeerGraph


	constructor: () ->
		super(@routes)

		@pure = $("""
			<div class="combine align-top">
				<div id="sidebar" class="combine align-right">
					<div id="ne"></div>
					<div id="profile-picture" class="cell">
						<img src="/cdn/images/profile_picture.jpg">
					</div>

					<div id="navigator" class="cell" style="display: none">
						<a href="/information/">Information</a>
						<a href="/technical_writing/">Technical Writing</a>
						<a href="/message_board/">Message Board</a>
						<a href="/resume/">Résumé</a>
						<a href="/sign_in/">Sign In</a>
						<a href="/peer_graph/">Peer Graph</a>
					</div>

				</div>
			</div>""")

		@sidebar = @pure.find("#sidebar")
		@profile_picture = @sidebar.find("#profile-picture")
		@navigator = @sidebar.find("#navigator")

		for name, SubApplication of @subapplications
			subapplication = new SubApplication(this)
			@[name] = subapplication
			console.log "appending", name
			subapplication.pure.appendTo(@pure)
			
		@profile_picture.click => @toggle_open()

		@intercept_internal_links()

		Backbone.history.start({ pushState: true, silent: true })


	default_navigation: (route) =>
		console.log "in navigation", route
		@open() if @is_closed()
		@close_all().then =>
			switch route
				when "message_board"
					@message_board.open()
				when "information"
					@information.open()
				when "technical_writing"
					console.log "opening technical", @technical
					@technical_writing.open()
				when "resume"
					@resume.open()
				when "sign_in"
					@authenticator.reset()
					@authenticator.open()
				when "sign_up"
					@authenticator.reset()
					@authenticator.open()
				when "peer_graph"
					@peer_graph.reset()
					@peer_graph.open()
				else
					console.warn("Unrecognized route: %s", route)


	close_all: (callback) =>
		console.log "in close_all"
		promises = []
		for subapplication in _(@subapplications).keys()
			promises.push new Promise (resolve) =>
				console.log "closing %s", subapplication
				@[subapplication].close(resolve)
		Promise.all(promises).then(callback)


	open: () =>
		@navigator.slideDown 300
		if (fragment = Backbone.history.fragment) != ""
			Backbone.history.loadUrl(fragment)


	close: () =>
		@close_all()
		@navigator.slideUp 300


	is_closed: () =>
		return @navigator.css('display') == "none"


	toggle_open: =>
		if @is_closed() then @open() else @close()


	intercept_internal_links: ->
		$(document).on 'click', (event) =>
			if event.target.host == window.location.host
				event.preventDefault()
				Backbone.history.navigate event.target.pathname,
					trigger:true