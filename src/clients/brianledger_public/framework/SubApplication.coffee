


class exports.SubApplication extends Backbone.Router

	constructor: (routes) ->
		super(routes)

		
	open: (callback) =>
		return callback?() unless @is_closed()
		@pure.animate {
			width: "25rem"
			height: "25rem"
			margin: "1px"
			padding: "4px"
		}, 300, =>
			@pure.css
				border: "1px solid gray"
			callback?()


	close: (callback) =>
		return callback?() if @is_closed()
		@pure.animate {
			width: 0
			height: 0
			margin: 0
			padding: 0
		}, 300, =>
			@pure.css
				border: "none"
			callback?()

			
	is_closed: => @pure.css('width') == "0px"


	toggle_open: =>
		if @is_closed() then @open() else @close()


	width: => @pure.outerWidth()


	height: => @pure.outerHeight()