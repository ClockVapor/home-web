lapis = require "lapis"
socket = require "socket"
import respond_to from require "lapis.application"

class extends lapis.Application
	@enable "etlua"
	layout: "layout"

	[index: "/"]: =>
		render: true

	[lights: "/lights"]: respond_to {
		GET: => render: true
		POST: =>
			tcp = socket.connect "127.0.0.1", 666
			if tcp
				tcp\send @params.color .. "\n"
				tcp\close!
			render: true
	}

