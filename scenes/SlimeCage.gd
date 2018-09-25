extends Node2D

var SlimeDna = preload("res://scripts/SlimeDna.gd")
var Slime = preload("res://scenes/Slime.tscn")

signal breeding

var slimes = []

var initial_offset
var spacing

const cols = 4
const rows = 5

const SLIME_PLACEHOLDER = "slime_placeholder"

func _ready():
	randomize()

	var vp = get_viewport()
	spacing = vp.size / 4.0
	initial_offset = spacing / 2.0

	create_slimes(vp.size / 2.0)

func create_slimes(initial_position):
	for i in range(rows * cols):
		slimes.append(create_slime(initial_position, i))


func create_slime(initial_position, index):
	var slime = Slime.instance()
	add_child(slime)
	slime.position = initial_position
	slime.move_to(position_from_index(index))
	slime.connect("breed", self, "breed")
	slime.connect("remove_slime", self, "remove_slime")
	return slime

func position_from_index(index):
	var col = index % cols
	var row = index / cols
	print("row, col:", index, ": ", row, ", ", col)
	return initial_offset + Vector2(spacing.x * col, spacing.y * row)

func breed(slime1, slime2):
	print("breeding")
	var new_slime_count = 0
	for i in range(len(slimes)):
		var item = slimes[i]
		match item:
			SLIME_PLACEHOLDER:
				var slime = create_slime(slime1.position, i)
				slimes[i] = slime
				slime.set_dna(slime1.dna.combine(slime2.dna))
				slime.deselect()
				new_slime_count += 1
	
	if new_slime_count > 0:
		emit_signal("breeding")

func remove_slime(slime):
	slimes[slimes.find(slime)] = SLIME_PLACEHOLDER
	slime.remove_slime()
