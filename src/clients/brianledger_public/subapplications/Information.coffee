
{ SubApplication } = require("../framework/SubApplication.coffee")

class exports.Information extends SubApplication

	constructor: () ->
		@pure=$("""
			<div id="information" class="cell" style="display: none; padding: 0; margin: 0">
				<h2>Basic Information</h2>
				<div class="row"><label>Name:</label><span class="attribute">Brian Peter Ledger</span></div>
				<div class="row"><label>Birthday:</label><span class="attribute">January 8th, 1988</span></div>
				<div class="row"><label>Hometown:</label><span class="attribute">Medford, NY</span></div>

				<h2>Contact Information</h2>
				<div class="row"><label>Email:</label><span class="attribute"><a href="mailto:brian.peter.ledger@gmail.com">brian.peter.ledger@gmail.com</a></span></div>
				<div class="row"><label>Phone Number:</label><span class="attribute"><a href="tel:16314135403">(631) 413-5403</a></span></div>
				<div class="row"><label>Current Address:<br/>&zwnj;</label><span class="attribute">126 Day Street<br/>Boston, MA 02130</span></div>
				<div class="row"><label>Website:</label><span class="attribute"><a href="https://brianledger.net">brianledger.net</a></span></div>

				<h2>Academic Information</h2>
				<div class="row"><label>College:</label><span class="attribute">Cornell '10</span></div>
				<div class="row"><label>High School:</label><span class="attribute">Longwood High School ’06</span></div>

				<h2>Personal Information</h2>
				<div class="row"><label>Activities:</label><span class="attribute">biking, sailing</span></div>

			</div>""")
		

	open: (callback) =>
		return callback?() unless @pure.css('display') == "none"
		@pure.css
			display: "block"
			'max-height': 0
			'max-width': "1px"
			'border-left': "1px solid gray"
		@pure.animate {
			'max-height': @pure_outer_height or "30rem"
		}, 300, =>
			@pure.css
				'border-left': ""
				border: "1px solid gray"
			@pure.animate {
				'max-width': @pure_outer_width or "100vw"
				padding: '4px'
				margin: '1px'
			}, 200, =>
				@pure.css
					'max-width': ""
					'max-height': ""
				callback?()


	close: (callback) =>
		return callback?() if @pure.css('display') == "none"
		@pure_outer_height = @pure.outerHeight()
		@pure_outer_width = @pure.outerWidth()

		@pure.css
			'max-height': @pure_outer_height
			'max-width': @pure_outer_width
		@pure.animate {
			'max-width': "1px"
			margin: 0
			padding: 0
		}, 300, =>
			@pure.css
				border: "none"
				'border-left': "1px solid gray"
			@pure.animate {
				'max-height': 0
				padding: 0
				margin: 0
			}, 200, =>
				@pure.css
					'display': "none"
					'border-left': ""
				callback?()


	get_width: => @pure.outerWidth()

	get_height: => @pure.outerHeight()
