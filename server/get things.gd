extends HTTPRequest

#Log, Jug, Wes, Eli, Zac, Kla
const channels = ["UC1xTO0ltDAq9wLM4prxM1XQ", "UCfCfOl1RK_bW-cGWSIHCERQ", "UCwz1Lc9OMDcjHSGWLpP9-vA", "UCB3zBd8TQJ5NlyJ6XaeYNSQ", "UC-surhCEnCkZf8E7VZ6zIoA", "UCpshZJwVFvSpfhKHoCTNcDQ"]

var queue = []

var subs = [0, 0, 0, 0, 0, 0]
var views = [0, 0, 0, 0, 0, 0]

var canSend = true

var timer = 300.0

func pingAll():
	queue = channels.duplicate()

func addToQueue(id):
	queue.push_back(channels[id])

func _on_request_completed(_result, _response_code, _headers, body):
	var json = JSON.parse_string(body.get_string_from_utf8())

	subs[channels.find(json["items"][0]["id"])] = int(json["items"][0]["statistics"]["subscriberCount"])
	views[channels.find(json["items"][0]["id"])] = int(json["items"][0]["statistics"]["viewCount"])

	print(json["items"][0]["statistics"]["subscriberCount"])
	print(json["items"][0]["statistics"]["viewCount"])

	canSend = true

func _physics_process(delta):
	timer -= delta

	if canSend && queue.size() > 0:
		request("https://www.googleapis.com/youtube/v3/channels?id=" + queue.pop_front() + "&key=AIzaSyB9qD11p1nG6yRkoP27-vojLTWOqxf4O7s&part=statistics")
		canSend = false
	
	rpc("setCounts", subs, views)


@rpc("call_remote") func setCounts(sub:Array, view:Array):
	pass
