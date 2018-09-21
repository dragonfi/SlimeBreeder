extends Node2D

var money = 0

func _ready():
	pass

#func _process(delta):
#	pass

func _on_Offers_slime_sold(slime, sell_value):
	$SlimeCage.remove_slime(slime)
	money += sell_value
	$UI/Money.text = "Money: %s" % money
