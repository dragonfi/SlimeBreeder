extends "res://scenes/Slime.gd"

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var label

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	label = get_node("Sprite/Label")
	
	label.text = "Color: %s\nSize: %s\nSpeed: %s\nDna: %s" % [color, size, idle_speed, dna]

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
