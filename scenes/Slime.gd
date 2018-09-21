extends Node2D

var SlimeDna = preload("res://scripts/slime_dna.gd")

signal pressed
signal breed

export var idle_speed = 1.0
export var color = Color(1, 1, 1, 1)
export var size = 1.0
var modulate_scale = Vector2(0.25, 0.25)
var speed = 100.0

var selected = false
var target_position = null
var dna

var drag_area
var animation_player
var sprite
var shine


func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	animation_player = get_node("AnimationPlayer")
	sprite = get_node("Sprite")
	shine = get_node("Sprite/Shine")

	speed = speed * (1.0 + randf())

	animation_player.playback_speed = idle_speed
	animation_player.queue("Idle")

	set_dna(SlimeDna.new_random_dna())

func _process(delta):
	if selected:
		return
	var direction = target_position - position
	if direction.length() < 1.0:
		return
	position += direction.normalized() * speed * delta

func set_dna(slime_dna):
	dna = slime_dna
	color = dna.get_color()

	shine.self_modulate = (color + Color(1, 1, 1, 1)) / 2
	sprite.self_modulate = color
	
	scale = Vector2(modulate_scale.x * size,  modulate_scale.y * size)

func move_to(position):
	target_position = position

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Idle":
		animation_player.queue("Idle")

func _on_Area2D_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		select()

func _input(event):
	if not selected:
		return

	if event is InputEventMouseButton and not event.pressed:
		deselect()
		for area in $Sprite/Area2D.get_overlapping_areas():
			if area.has_method("slime_dropped"):
				area.slime_dropped(self)

	if event is InputEventMouseMotion and Input.is_mouse_button_pressed(BUTTON_LEFT):
		global_position += event.relative

func highlight(magnitude):
	modulate = Color(magnitude, magnitude, magnitude, 1.0)

func _on_Area2D_mouse_entered():
	if not selected:
		highlight(1.5)

func _on_Area2D_mouse_exited():
	if not selected:
		highlight(1.0)

func select():
	if selected:
		return
	selected = true
	z_index += 10
	highlight(1.8)

func deselect():
	if not selected:
		return
	selected = false
	z_index -= 10
	highlight(1.0)

func _on_Area2D_slime_dropped(other):
	emit_signal("breed", self, other)
