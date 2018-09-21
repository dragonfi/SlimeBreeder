extends Area2D

signal slime_dropped

func _ready():
	pass

func slime_dropped(slime):
	emit_signal("slime_dropped", slime)

#func _process(delta):
#	pass
