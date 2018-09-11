extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var SlimeDna = preload("res://scripts/slime_dna.gd")
var Slime = preload("res://scenes/Slime.tscn")

var selected_slimes = []
var slimes = []

func _ready():
	randomize()
	var vp = get_viewport()
	var spacing = vp.size / 4.0
	var initial_offset = spacing / 2.0
	for i in range(4):
		for j in range(5):
			var slime = Slime.instance()
			add_child(slime)
			slime.position = initial_offset + Vector2(spacing.x * i, spacing.y * j)
			slime.connect("pressed", self, "_on_Slime_pressed")
			slimes.append(slime)

func breed():
	print("breeding")
	for slime in slimes:
		slime.set_dna(selected_slimes[0].dna.combine(selected_slimes[1].dna))
		slime.deselect()
	selected_slimes = []

func _on_Slime_pressed(slime):
	if not slime in selected_slimes:
		selected_slimes.append(slime)
	else:
		selected_slimes.remove(selected_slimes.find(slime))
		slime.deselect()
	if len(selected_slimes) >= 2:
		breed()
