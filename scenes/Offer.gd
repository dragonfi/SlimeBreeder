extends Panel

signal slime_sold

var value
var condition
var description
var side_effect

var is_completed = false

func _ready():
	$AnimationPlayer.play("FadeIn")

func init(d, v, c, _side_effect = null):
	description = d
	value = v
	condition = c
	side_effect = _side_effect if _side_effect != null else funcref(self, "_pass")
	$Description.text = description
	$Price.text = str(value)

func _pass():
	pass

#func _process(delta):
#	pass

func is_fulfilled_by(slime):
	return condition.is_fulfilled_by(slime)

func _on_Area2D_slime_dropped(slime):
	if is_fulfilled_by(slime) and not is_completed:
		is_completed = true
		side_effect.call_func()
		emit_signal("slime_sold", slime)
		$AnimationPlayer.connect("animation_finished", self, "_free")
		$AnimationPlayer.play("FadeOut")

func _free(name):
	if name  == "FadeOut":
		queue_free()
