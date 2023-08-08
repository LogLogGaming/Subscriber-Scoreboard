extends HTTPRequest

#Log, Jug, Wes, Eli, Zac
const channels = ["UC1xTO0ltDAq9wLM4prxM1XQ", "UCfCfOl1RK_bW-cGWSIHCERQ", "UCwz1Lc9OMDcjHSGWLpP9-vA", "UCB3zBd8TQJ5NlyJ6XaeYNSQ", "UC-surhCEnCkZf8E7VZ6zIoA", "UCpshZJwVFvSpfhKHoCTNcDQ"]

var subs = [0, 0, 0, 0, 0, 0]
var views = [0, 0, 0, 0, 0, 0]

var timer = 300.0

func _ready():
	request("https://www.googleapis.com/youtube/v3/channels?id=" + channels[0] + "&key=AIzaSyB9qD11p1nG6yRkoP27-vojLTWOqxf4O7s&part=statistics")

func _on_request_completed(_result, _response_code, _headers, body):
	var json = JSON.parse_string(body.get_string_from_utf8())
	
	subs[channels.find(json["items"][0]["id"])] = int(json["items"][0]["statistics"]["subscriberCount"])
	views[channels.find(json["items"][0]["id"])] = int(json["items"][0]["statistics"]["viewCount"])
	print(json["items"][0]["statistics"]["subscriberCount"])
	print(json["items"][0]["statistics"]["viewCount"])
	if channels.find(json["items"][0]["id"]) != channels.size() - 1:
		request("https://www.googleapis.com/youtube/v3/channels?id=" + channels[channels.find(json["items"][0]["id"]) + 1] + "&key=AIzaSyB9qD11p1nG6yRkoP27-vojLTWOqxf4O7s&part=statistics")

func _process(delta):
	timer -= delta
	if timer <= 0:
		timer = 300.0
		request("https://www.googleapis.com/youtube/v3/channels?id=" + channels[0] + "&key=AIzaSyB9qD11p1nG6yRkoP27-vojLTWOqxf4O7s&part=statistics")
