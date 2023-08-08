extends Node3D

const possibleMusic = ["airport_lounge", "itty_bitty_8_bit", "motivator", "movement_proposition", "new_friendly", "pinball_spring", "pixel_peeker_polka", "radio_martini", "unreal_superhero_3"]

@onready var people = [$LogLog, $Jugg, $WestCraft15, $Elili, $ThePeashooter23, $M3KAI5ER44]
@onready var things = $HTTPRequest

@onready var music = $Music
@onready var camera = $Camera3D

var STOP = false
var saw_it = FileAccess.file_exists("user://SaveFile1.sav")

var mode = "subs"

func _ready():
	for i in range(1, 6):
		var grass = load("res://grass/" + String.num(i) + ".tscn")
		for j in range(150 * i + 100):
			var newGrass = grass.instantiate()
			newGrass.position.x = randf_range(-i * 200, i * 200)
			newGrass.position.z = randf_range(-i * 200, i * 200)
			add_child(newGrass)

func _process(_delta):
	for i in range(people.size()):
		if mode == "subs":
			people[i].pillar.scale.y = things.subs[i] * .1
			if things.subs[i] == 0:
				people[i].pillar.visible = false
			else:
				people[i].pillar.visible = true
			people[i].sprite.position.y = things.subs[i] * .05 + .755
			people[i].sprite.frame = i * 5
			people[i].text.position.y = things.subs[i] * .05 - (.25 if things.subs[i] >= 9 else -.25)
			people[i].text.text = String.num(things.subs[i])
		if mode == "views":
			people[i].pillar.scale.y = things.views[i] * .001
			if things.views[i] == 0:
				people[i].pillar.visible = false
			else:
				people[i].pillar.visible = true
			people[i].sprite.position.y = things.views[i] * .0005 + .755
			people[i].sprite.frame = i * 5
			people[i].text.position.y = things.views[i] * .0005 - (.25 if things.views[i] >= 900 else -.25)
			people[i].text.text = String.num(things.views[i])
	
	if !STOP && !saw_it && (camera.position.x > 1000 || camera.position.x < -1000 || camera.position.z > 1000 || camera.position.z < -1000):
		music.stream = load("res://music/mu_thief.ogg")
		music.play()
		$Ground.set_surface_override_material(0, load("res://ground2.tres"))
		$WorldEnvironment.environment = load("res://environment2.tres")
		for i in range(people.size()):
			people[i].visible = false
		$spr_heaven.visible = true
		STOP = true
	
	if STOP && !saw_it && (camera.position.x < 100 && camera.position.x > -100 && camera.position.z < 100 && camera.position.z > -100):
		music.playing = false
		$Ground.set_surface_override_material(0, load("res://ground1.tres"))
		$WorldEnvironment.environment = load("res://environment1.tres")
		for i in range(people.size()):
			people[i].visible = true
		$spr_heaven.visible = false
		saw_it = true
		var saveFile = FileAccess.open("user://SaveFile1.sav", FileAccess.WRITE)
		saveFile.store_string("another lost soul has come here")
		saveFile.close()
	
	if Input.is_action_just_pressed("ui_accept"):
		music.playing = false
	
	if Input.is_action_just_pressed("ui_down"):
		music.volume_db -= 5
	
	if Input.is_action_just_pressed("ui_up"):
		music.volume_db += 5
	
	if Input.is_action_just_pressed("ui_left"):
		mode = "views"
	
	if Input.is_action_just_pressed("ui_right"):
		mode = "subs"
	
	if !music.playing:
		music.stream = load("res://music/" + possibleMusic[randi_range(0, possibleMusic.size() - 1)] + ".mp3")
		music.play()
		
