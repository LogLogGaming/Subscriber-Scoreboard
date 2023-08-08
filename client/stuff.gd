extends Node

var subs = [0, 0, 0, 0, 0, 0]
var views = [0, 0, 0, 0, 0, 0]

@rpc("authority") func setCounts(sub:Array, view:Array):
	subs = sub.duplicate()
	views = view.duplicate()
