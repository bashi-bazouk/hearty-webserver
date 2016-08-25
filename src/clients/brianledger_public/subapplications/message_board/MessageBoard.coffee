{ SubApplication } = require("../../framework/SubApplication.coffee")
{ Message } = require("./Message.coffee")

window.api ?= { }
api['message_board'] =
	message: (name="") ->
		get: () ->
			new Promise (resolve, reject) ->
				d3.msgpack "/message_board/message/#{ name }", (error, data) ->
					if data? then resolve(data) else reject(error)
		post: (data) ->
			new Promise (resolve, reject) ->
				if name then name = "/" + name
				d3.msgpack("/message_board/message#{ name }")
					.post msgpack.encode(data), (error, data) ->
						if data? then resolve(data) else reject(error)


class exports.MessageBoard extends SubApplication

	constructor: () ->
		@pure = $("""
			<div id="message-board" class="combine align-top" style="max-width: 0; max-height: 0">
				<div id="messages"></div>
				<button id="post-message" disabled >Post</button>
			</div>""")

		@messages = @pure.find("#messages")
		@post = @pure.find("#post-message")

		@initial_message = new Message()
		@initial_message.keyup => @check_input()

		@initial_message.pure.prependTo(@messages)

		@post.click => @post_message()


	load_messages: () =>
		api.message_board.message("*").get().then (messages) =>
			message_pairs = _(messages).pairs().map ([name, data]) -> [name.split(" - "), data['content']]
			message_pairs = _(message_pairs).sortBy (name) -> -parseInt(name[0])
			for [id, content] in message_pairs
				message = new Message()
				message.pure.removeAttr('contentEditable')

				message.pure.html(content)
				message.pure.find("iframe").attr('sandbox', "allow-scripts allow-same-origin")
				message.pure.appendTo(@messages)


	post_message: () =>
		[@initial_message, message] = @initial_message.cleave(@post.outerHeight())

		# Need to swap the special attributes onto the new input.
		message.pure.removeAttr('id')
		message.pure.off('keyup')
		@initial_message.pure.attr('id', "message")
		@initial_message.keyup => @check_input()

		#@post.attr('disabled', "")
		api.message_board.message().post(message.json())



	check_input: () =>
		message =  @initial_message.json()
		if message.content.length > 3
			@post.removeAttr('disabled')
		else
			@post.attr('disabled', "")


	open: () =>
		if not @opened_once?
			@load_messages()

		pure_outer_width = @pure.outerWidth()

		return unless pure_outer_width == 0
		@pure.css
			display: "flex"
			'border-left': "1px solid gray"
		@pure.animate {
			'max-height': @pure_outer_height or "100vh"
		}, 350, "linear", =>
			@pure.css
				'border-left': "none"
			@pure.animate {
				'max-width': @pure_outer_width or "100vw"
			}, 150, "linear", =>
				@pure.css
					'max-width': ""
					'max-height': ""


	close: (callback) =>
		@pure_outer_width = @pure.outerWidth()
		@pure_outer_height = @pure.outerHeight()
		return callback?() if @pure_outer_width == 0

		@pure.css
			'max-height': @pure_outer_height
			'max-width': @pure_outer_width
		@pure.animate {
			'max-height': 0
		}, 300, "swing", =>
			@pure.css

				'border-top': "1px solid gray"
			@pure.animate {
				'max-width': 0
			}, 100, "swing", =>
				@pure.css
					display: "none"
					'border-top': "none"
				callback?()