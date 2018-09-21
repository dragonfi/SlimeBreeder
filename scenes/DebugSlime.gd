extends "res://scenes/Slime.gd"

var label

func _ready():
	label = get_node("Sprite/Label")
	label.text = "Color: %s\nSize: %s\nSpeed: %s\nDna: %s" % [color, size, idle_speed, dna]

#func _process(delta):
#	pass
