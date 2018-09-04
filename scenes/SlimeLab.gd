extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var SlimeDna = preload("res://scripts/slime_dna.gd")

var selected_dna = []
var slimes

func _ready():
	slimes = [get_node("Slime"), get_node("Slime2"), get_node("Slime3"), get_node("Slime4")]

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
