extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var SlimeDna = preload("res://scripts/slime_dna.gd")
var Slime = preload("res://scenes/Slime.tscn")

var slimes = []

var initial_offset
var spacing

const cols= 4
const rows = 5

func _ready():
	randomize()

	var vp = get_viewport()
	spacing = vp.size / 4.0
	initial_offset = spacing / 2.0

	create_slimes(vp.size / 2.0)

func create_slimes(initial_position):
	for i in range(rows):
		for j in range(cols):
			var slime = Slime.instance()
			add_child(slime)
			slime.position = initial_position
			slime.move_to(position_from_index(i * cols + j))
			slime.connect("breed", self, "breed")
			slimes.append(slime)
	
func position_from_index(index):
	var col = index % cols
	var row = index / cols
	print("row, col:", index, ": ", row, ", ", col)
	return initial_offset + Vector2(spacing.x * col, spacing.y * row)

func breed(slime1, slime2):
	print("breeding")
	for slime in slimes:
		slime.queue_free()
	slimes = []
	
	create_slimes(slime1.position)
	
	for slime in slimes:
		slime.set_dna(slime1.dna.combine(slime2.dna))
		slime.deselect()

func remove_slime(slime):
	slimes.erase(slime)
	slime.queue_free()
