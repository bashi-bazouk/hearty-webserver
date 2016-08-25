
{ SubApplication } = require("../framework/SubApplication.coffee")

class exports.Resume extends SubApplication

	constructor: (@application) ->
		@pure=$("""
			<div id="resume" style="max-width: 0px; max-height: 0px; padding: 0px; margin: 0px; border: none">
				<iframe src="/cdn/documents/Brian P Ledger Resume.pdf"></iframe>
			</div>""")
		

	open: (callback) =>
		return callback?() unless @pure.css('width') == "0px"
		@pure.animate {
			'max-width': "21.6cm"
			'max-height': "30.5cm"
			margin: "1px"
			padding: "4px"
		}, 300, =>
			@pure.css
				border: "1px solid gray"
			callback?()


	close: (callback) =>
		console.log "closing!"
		return callback?() if @pure.css('width') == "0px"
		@pure.animate {
			'max-width': 0
			'max-height': 0
			margin: 0
			padding: 0
		}, 300, =>
			@pure.css
				border: "none"
			callback?()


	is_closed: => @pure.css('width') == "0px"