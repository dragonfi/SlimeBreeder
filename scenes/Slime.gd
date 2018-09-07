extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

signal pressed

var selected = false

var SlimeDna = preload("res://scripts/slime_dna.gd")

var animation_player
var sprite
var shine

var dna

export var idle_speed = 1.0
export var color = Color(1, 1, 1, 1)
export var size = 1.0
var modulate_scale = 0.5

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	animation_player = get_node("AnimationPlayer")
	sprite = get_node("Sprite")
	shine = get_node("Sprite/Shine")

	modulate_scale = scale

	animation_player.playback_speed = idle_speed
	animation_player.queue("Idle")

	set_dna(SlimeDna.new_random_dna())

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func set_dna(slime_dna):
	dna = slime_dna
	color = dna.get_color()

	shine.self_modulate = (color + Color(1, 1, 1, 1)) / 2
	sprite.self_modulate = color
	
	scale = Vector2(modulate_scale.x * size,  modulate_scale.y * size)

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Idle":
		animation_player.queue("Idle")


func _on_Area2D_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		print("mouse button pressed")
		select()
		emit_signal("pressed", self)

func highlight(magnitude):
	modulate = Color(magnitude, magnitude, magnitude, 1.0)

func _on_Area2D_mouse_entered():
	if not selected:
		highlight(1.5)

func _on_Area2D_mouse_exited():
	if not selected:
		highlight(1.0)

func select():
	selected = true
	highlight(1.8)

func deselect():
	selected = false
	highlight(1.0)