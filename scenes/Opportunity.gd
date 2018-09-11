extends Button

# TODO: rename to Order

var value
var evaluator

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	#evaluator = funcref(self, "return_false")
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func return_false(slime):
	return false

func is_fulfilled_by(slime):
	print(evaluator)
	return evaluator.call_func(slime)

func init(description, v, e):
	print(evaluator)
	value = v
	evaluator = e
	$Description.text = description
	$Price.text = str(value)
