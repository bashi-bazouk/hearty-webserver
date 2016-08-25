

$.ajaxSetup
	beforeSend: (xhr) ->
		xsrf_token = document.cookie.match("\\b" + name + "=([^;]*)\\b")?[1]
		if xsrf_token
			xhr.setRequestHeader('X-XSRFToken', xsrf_token)
		else
			console.warn "no xsrf token"


d3.msgpack = (url, callback) ->
	xsrf_token = document.cookie.match("\\b" + name + "=([^;]*)\\b")?[1]
	if not xsrf_token
		console.warn "no xsrf token"

	xhr = d3.xhr(url)
		.header('X-XSRFToken', xsrf_token)
		.responseType("arraybuffer")
		.response (request) ->
			if request.response.byteLength > 0
				msgpack.decode(request.response)
			else
				""

	if callback?
		xhr.get(callback)
	else
		xhr