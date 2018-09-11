extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var Opportunity = preload("res://scenes/Opportunity.tscn")
var list

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	list = $ScrollContainer/VBoxContainer
	for i in range(10):
		add_opportunity()

func add_opportunity():
	var opportunity = Opportunity.instance()
	opportunity.connect("pressed", self, "_on_opportunity_pressed")
	list.add_child(opportunity)
	list.queue_sort()
	$ScrollContainer.queue_sort()

func _on_opportunity_pressed():
	print("pressed")
	add_opportunity()

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
