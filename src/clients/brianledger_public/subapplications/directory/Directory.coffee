
{ SubApplication } = require("../../framework/SubApplication.coffee")

class exports.Directory extends SubApplication

	constructor: (@application) ->
		@pure=$("""<div id="directory"></div>""")

	open: =>
		@pure.addClass("full-screen")

	close: =>
		@pure.removeClass("full-screen")

	is_closed: =>
		return !@pure.hasClass("full-screen")