extends Panel

signal slime_sold

var value
var evaluator
var description

var is_completed = false

func _ready():
	$AnimationPlayer.play("FadeIn")

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
	if is_fulfilled_by(slime) and not is_completed:
		is_completed = true
		emit_signal("slime_sold", slime)
		$AnimationPlayer.connect("animation_finished", self, "_free")
		$AnimationPlayer.play("FadeOut")

func _free(name):
	if name  == "FadeOut":
		queue_free()
