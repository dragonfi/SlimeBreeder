extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
signal slime_sold
var Opportunity = preload("res://scenes/Opportunity.tscn")
var list

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	list = $ScrollContainer/VBoxContainer
	for i in range(5):
		add_opportunity("Please bring me a slime", 10, funcref(self, "any_slime"))

func any_slime(slime):
	return true

func add_opportunity(description, value, evaluator):
	print(evaluator)
	var o = Opportunity.instance()
	o.init(description, value, evaluator)
	list.add_child(o)
	list.queue_sort()
	$ScrollContainer.queue_sort()
	o.connect("pressed", self, "_on_opportunity_pressed", [o])


func _on_opportunity_pressed(opportunity):
	print("pressed")
	if opportunity.is_fulfilled_by(null):
		print("fullfilled")
		emit_signal("slime_sold", opportunity.value)
		opportunity.queue_free()
	else:
		print("invalid slime for order")

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
