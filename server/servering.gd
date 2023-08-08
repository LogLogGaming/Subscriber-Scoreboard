extends Node2D

@onready var stuff = $stuff

const defaultTimers = [60.0, 60.0, 60.0, 300.0, 300.0, 600.0]
var timers = defaultTimers.duplicate()

const usernames = ["LogLog", "Juggabugg", "WestCraft15", "Elili", "ThePeashooter23", "M3KAI5ER44"]

var server = ENetMultiplayerPeer.new()

func _ready():
	server.create_server(25566)
	multiplayer.multiplayer_peer = server
	stuff.pingAll()

func _physics_process(delta):
	$Label.text = String.num(multiplayer.get_peers().size()) + " Connection(s)\n\nSubscribers:"
	for i in range(6):
		$Label.text += "\n" + usernames[i] + ": " + String.num(stuff.subs[i])

	$Label.text += "\n\nViews: "

	for i in range(6):
		$Label.text += "\n" + usernames[i] + ": " + String.num(stuff.views[i])
		timers[i] -= delta
		if timers[i] <= 0:
			stuff.addToQueue(i)
			timers[i] += defaultTimers[i]
