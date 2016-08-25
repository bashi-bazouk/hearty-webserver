
{ SubApplication } = require("../../framework/SubApplication.coffee")

window.api ?= { }
api['account'] = () ->
	post: (sign_in) ->
		new Promise (resolve, reject) ->
			d3.msgpack("/account")
				.post msgpack.encode(sign_in), (error, data) ->
					if data? then resolve(data) else reject(error)
	put: (sign_up) ->
		new Promise (resolve, reject) ->
			d3.msgpack("/account")
				.send 'PUT', msgpack.encode(sign_up), (error, data) ->
					if data? then resolve(data) else reject(error)


class exports.Authenticator extends SubApplication

	constructor: ->
		@pure = $("""
			<div id="authenticator" class="cell" style="width: 0; height: 0; margin: 0; padding: 0; border: none">

				<div id="sign-in">
					<div id="sign-in-with-email">
						<h1>Sign In</h1>
						<div class="error"></div>
						<div class="info">
							<input id="email" placeholder="Email">
							<input id="password" type="password" placeholder="Password">
						</div>
						<div class="actions">
							<button id="go-to-sign-up">Register</button>
							<button id="submit-sign-in-with-email" class="disabled">Sign In</button>
						</div>
					</div>
				</div>

				<div id="sign-up">
					<div id="sign-up-with-email">
						<h1>Register</h1>
						<div class="error"></div>
						<div class="info">
							<input id="name" placeholder="Name">
							<input id="email" placeholder="Email">
							<input type="password" id="password" placeholder="Password">
							<input type="password" id="repeat-password" placeholder="Repeat Password">
						</div>
						<div class="actions" style="width: unset">
							<button id="submit-sign-up-with-email" class="disabled">Register</button>
						</div>
					</div>
				</div>
			</div>""")

		@sign_in = @pure.find("#sign-in")
		@sign_in_button = @sign_in.find("#submit-sign-in-with-email")
		@sign_in.find("#go-to-sign-up").click -> Backbone.history.navigate("/sign_up/", { trigger: true })
		@sign_in.find("#sign-in-with-email input").keyup => @validate_sign_in()
		@sign_in_button.hover => @sign_in.find(".error").css 'visibility', "visible"
		@sign_in_button.click => @submit_sign_in()

		@sign_up = @pure.find("#sign-up")
		@sign_up_button = @sign_up.find("#submit-sign-up-with-email")
		@sign_up.find("#sign-up-with-email input").keyup => @validate_sign_up()
		@sign_up_button.hover => @sign_up.find(".error").css 'visibility', "visible"
		@sign_up_button.click => @submit_sign_up()


	validate_sign_in: (quiet=true, set_button=true) =>
		email = @sign_in.find("#sign-in-with-email #email").val()
		password = @sign_in.find("#sign-in-with-email #password").val()

		valid_email = ///^([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5})$///.test(email)
		valid_password = ///^...+$///.test(password)

		if valid_email and valid_password
			@sign_in.find(".error").text("")
			if set_button
				@sign_in.find("#submit-sign-in-with-email").removeClass("disabled")
			return { email, password }
		else
			if not quiet
				if not valid_email
					@sign_in.find(".error").text("Invalid email address.")
				else if not valid_password
					@sign_in.find(".error").text("Password must be more than 3 characters.")
			@sign_in.find("#submit-sign-in-with-email").addClass("disabled")
			return null


	validate_sign_up: () =>
		name = @sign_up.find("#sign-up-with-email #name").val()
		email = @sign_up.find("#sign-up-with-email #email").val()
		password = @sign_up.find("#sign-up-with-email #password").val()
		repeat_password = @sign_up.find("#sign-up-with-email #repeat-password").val()
		
		
		valid_name = ///^[^\\/?%*:|"<>\.]*$///.test(name)
		valid_email = ///^([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5})$///.test(email)
		valid_password = ///^...+$///.test(password)
		passwords_match = password == repeat_password

		# Helpers.
		error_text = (t) => @sign_up.find(".error").text(t)
		disable_sign_up_button = () =>
			@sign_up.find("#submit-sign-up-with-email").addClass("disabled")

		# Catch and set errors.
		if not valid_name
			error_text("A name cannot contain any of \/?%*:|\"<>.")
			disable_sign_up_button()
		else if not valid_email
			error_text("Please provide a valid email address.")
			disable_sign_up_button()
		else if not valid_password
			error_text("A password should have 4 or more characters.")
			disable_sign_up_button()
		else if not passwords_match
			error_text("Passwords do not match. Did you make a mistake?")
			disable_sign_up_button()
		else
			error_text("")
			@sign_up.find("#submit-sign-up-with-email").removeClass("disabled")
			return { name, email, password }
		return null


	submit_sign_in: () =>
		sign_in_request = @validate_sign_in(false)
		if sign_in_request?
			api.account().post(sign_in_request).then ((info) => @sign_in_success(info)),
				(error) => @sign_in_error(error)


	submit_sign_up: () =>
		sign_up_request = @validate_sign_up(false)
		if sign_up_request?
			api.account().put(sign_up_request).then (=> @sign_up_success()),
				(error) => @sign_up_error(error)


	sign_in_success: (@account) =>
		console.log "Sign in got success", @account


	sign_in_error: (error) =>
		console.log "Sign in got error", error
		switch error.status
			when 401
				@sign_in.find(".error").text("There is no account for these credentials.")
			else
				console.warn "uncaught error code", error.status


	sign_up_success: () =>
		console.log "all signed up!"


	sign_up_error: (error) =>
		console.log "sign up got error", error


	# Tweens

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

	reset: () =>
		switch location.pathname
			when "/sign_in/"
				unless @sign_in.is(":first-child")
					if @is_closed()
						@sign_in.detach().prependTo(@pure)
					else
						@go_to_sign_in()

			when "/sign_up/"
				unless @sign_up.is(":first-child")
					if @is_closed()
						@sign_up.detach().prependTo(@pure)
					else
						@go_to_sign_up()

			else
				console.warn "unrecognized route", location



	go_to_sign_in: (jump=false) =>
		return if @sign_in.is(":first-child")
		if jump
			@sign_in.detach().prependTo(@pure)
		else
			@pure.animate {
				opacity: 0
			}, 150, =>
				@sign_in.detach().prependTo(@pure)
				setTimeout (() =>
					@pure.animate {
						opacity: 1
					}, 150
				), 100


	go_to_sign_up: (jump=false) =>
		return if @sign_up.is(":first-child")
		if jump
			@sign_up.detach().prependTo(@pure)
		else
			@pure.animate {
				opacity: 0
			}, 150, =>
				@sign_up.detach().prependTo(@pure)
				setTimeout (() =>
					@pure.animate {
						opacity: 1
					}, 150
				), 100