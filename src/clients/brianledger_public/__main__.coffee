
require("./__init__.coffee")
{ Application } = require("./Application.coffee")

$(document).ready ->
	window.application = new Application()
	$("body").append(application.pure)