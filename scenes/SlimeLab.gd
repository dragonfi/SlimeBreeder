extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var SlimeDna = preload("res://scripts/slime_dna.gd")
var Slime = preload("res://scenes/Slime.tscn")

var selected_dna = []
var slimes = []

func _ready():
	var vp = get_viewport()
	var spacing = vp.size / 4.0
	var initial_offset = spacing / 2.0
	for i in range(4):
		for j in range(4):
			var slime = Slime.instance()
			add_child(slime)
			slime.position = initial_offset + Vector2(spacing.x * i, spacing.y * j)
			slime.connect("pressed", self, "_on_Slime_pressed")
			slimes.append(slime)

func breed():
	print("breeding")
	for slime in slimes:
		slime.set_dna(SlimeDna.combine_dna(selected_dna[0], selected_dna[1]))
		slime.deselect()
	selected_dna = []

func _on_Slime_pressed(slime):
	selected_dna.append(slime.dna)
	if len(selected_dna) >= 2:
		breed()
