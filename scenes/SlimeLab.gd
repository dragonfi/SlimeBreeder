extends Node2D

var money = 0
var day = 0

func _ready():
	pass

#func _process(delta):
#	pass

func _on_Offers_slime_sold(slime, sell_value, offer):
	$SlimeCage.remove_slime(slime)
	money += sell_value
	$UI/HBoxContainer/Money.text = "Money: %s" % money


func _on_SlimeCage_breeding():
	day += 1
	$UI/HBoxContainer/Day.text = "Day: %s" % day

func _on_RemoveButton_toggled(button_pressed):
	GlobalState.is_remove_mode_active = button_pressed

func _input(event):
	if event is InputEventKey and event.scancode == KEY_CONTROL:
		$UI/HBoxContainer/RemoveButton.pressed = event.is_pressed()
		GlobalState.is_remove_mode_active = event.is_pressed()
