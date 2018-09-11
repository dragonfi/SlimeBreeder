extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var current_scene
var money = 0

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func change_to_scene(scene):
	current_scene = scene
	scene.show()
	$BackButton.show()
	$MainMenu.hide()

func change_to_main_menu():
	if current_scene:
		current_scene.hide()
		current_scene = null
	$BackButton.hide()
	$MainMenu.show()

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_SlimeCageButton_pressed():
	change_to_scene($SlimeCage)


func _on_OpportunitiesButton_pressed():
	pass # replace with function body


func _on_BackButton_pressed():
	change_to_main_menu()


func _on_Opportunities_slime_sold(sell_value):
	money += sell_value
	$UI/Money.text = "Money: %s" % money
