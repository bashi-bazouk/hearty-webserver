
class exports.Message

	constructor: (attributes={ 'data-placeholder': "Leave a message." }) ->
		@pure = $("""<div class="message cell" contentEditable="true"></div>""")
		@pure.attr(attributes)


	cleave: (outer_height, duration=250) =>

		keyframe = (time, callback) -> setTimeout(callback, time)

		height = outer_height - 8 - 2
		distance = outer_height + 2
		console.log "got height, distance, duration", outer_height, distance, duration

		duration =
			'interphase': (height / distance) * duration
			'anaphase': (8 / distance) * duration
			'telophase': (2 / distance) * duration

		phase_start = (keyframe) ->
			switch keyframe
				when 'interphase' then 0
				when 'anaphase' then phase_start('interphase') + duration['interphase']
				when 'telophase' then phase_start('anaphase') + duration['anaphase']

		start = _(duration).mapObject (d, phase) -> phase_start(phase)

		@pure.attr('contentEditable', false)

		@pure.css
			'padding-top': 0
			'border-top-width': 0
			'margin-top': 0
			'-webkit-border-top-right-radius': 0
			'-webkit-border-top-left-radius': 0
			'-moz-border-radius-topright': 0
			'-moz-border-radius-topleft': 0
			'border-top-right-radius': 0
			'border-top-left-radius': 0

		sister = new exports.Message()
		sister.pure.css
			'height': 0
			'padding-bottom': 0
			'border-bottom-width': 0
			'margin-bottom': 0
			'-webkit-border-bottom-right-radius': 0
			'-webkit-border-bottom-left-radius': 0
			'-moz-border-radius-bottomright': 0
			'-moz-border-radius-bottomleft': 0
			'border-bottom-right-radius': 0
			'border-bottom-left-radius': 0

		sister.pure.insertBefore(@pure)

		keyframe start['interphase'], =>
			sister.pure.animate { height: "#{ outer_height }px" }, duration['interphase'], "swing"


		keyframe start['anaphase'], =>

			@pure.animate { 'padding-top': '4px' }, duration['anaphase'], "linear", =>
				@pure.css
					'-webkit-border-top-right-radius': "2px"
					'-webkit-border-top-left-radius': "2px"
					'-moz-border-radius-topright': "2px"
					'-moz-border-radius-topleft': "2px"
					'border-top-right-radius': "2px"
					'border-top-left-radius': "2px"

			sister.pure.animate { 'padding-bottom': "4px" }, duration['anaphase'], "linear", ->
				sister.pure.css
					'-webkit-border-bottom-right-radius': "2px"
					'-webkit-border-bottom-left-radius': "2px"
					'-moz-border-radius-bottomright': "2px"
					'-moz-border-radius-bottomleft': "2px"
					'border-bottom-right-radius': "2px"
					'border-bottom-left-radius': "2px"

		keyframe start['telophase'], =>

			@pure.css 'border-top-width', "1px"
			@pure.animate { 'margin-top': '2px' }, duration['telophase']

			sister.pure.css 'border-bottom-width', "1px"
			sister.pure.animate { 'margin-bottom': "2px" }, duration['telophase'], ->
				sister.pure.css('height', "")



		return [sister, this]


	json: (maybe_json) =>
		if (json=maybe_json)?
			pass
		else
			return { content: @pure.html() }


	placeholder: (maybe_placeholder) =>
		if (placeholder = maybe_placeholder)?
			@pure.attr('data-placeholder', placeholder)
			return this
		else
			return @pure.attr('data-placeholder')


	keyup: (callback) =>
		@pure.keyup callback
