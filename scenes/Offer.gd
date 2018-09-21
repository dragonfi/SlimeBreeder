extends Button

signal slime_sold

var value
var evaluator
var description

func _ready():
	pass

func init(d, v, e):
	description = d
	value = v
	evaluator = e
	$Description.text = description
	$Price.text = str(value)

#func _process(delta):
#	pass

func is_fulfilled_by(slime):
	print(evaluator)
	return evaluator.call_func(slime)

func _on_Area2D_slime_dropped(slime):
	if is_fulfilled_by(slime):
		emit_signal("slime_sold", slime)
		self.queue_free()
