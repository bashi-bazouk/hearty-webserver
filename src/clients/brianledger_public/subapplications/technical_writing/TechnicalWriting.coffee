
{ markdown } = require("markdown")

{ SubApplication } = require("../../framework/Subapplication.coffee")

content = require("./content.md")

console.log "got content", content

class exports.TechnicalWriting extends SubApplication
	
	constructor: (@application) ->
		@pure=$("""<div id="technical-writing" class="markdown cell" style="display: none" ></div>""")
		@load_markdown()

		@pure.mousedown (event) => @mousedown(event)
		@pure.mousemove (event) => @mousemove(event)
		$(document).mouseup (event) => @mouseup()


	load_markdown: (filename) =>
		@pure.html(markdown.toHTML(content))


	mousedown: (event) =>
		initial_x = event['pageX']
		initial_scroll = @pure.scrollLeft()
		@dragging = { initial_x, initial_scroll	}
		console.log "mousedown", event


	mousemove: (event) =>
		if @dragging?
			console.log "mousemove", event.pageX
			new_x = event['pageX']
			delta = @dragging['initial_x'] - new_x
			new_scroll = @dragging['initial_scroll'] + delta
			@pure.scrollLeft(new_scroll)

	mouseup: =>
		console.log "mouseup"
		@dragging = null

	open: =>
		sidebar_width = @application.sidebar.outerWidth() + 4 # for margin

		full_screen_width = 100 * (1 - (sidebar_width / window.innerWidth))

		@pure.css('display', "flex")
		@pure.animate {
			margin: 1
			'padding': "0.5in"
			'border-width': 1
			width: "#{ full_screen_width }vw"
			height: "#{ 100 * (window.innerHeight - 4) / window.innerHeight }vh"
		}, 300, "swing", =>
			@pure.css
				width: "calc(100vw - 1.5in - 16px)"


	close: (callback) =>
		@pure.animate {
			margin: 0
			padding: 0
			'border-width': 0
			width: 0
			height: 0
		}, 300, "swing", =>
			@pure.css('display', "none")
			callback()
		
	