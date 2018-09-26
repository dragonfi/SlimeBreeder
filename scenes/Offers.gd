extends Node2D

var Offer = preload("res://scenes/Offer.tscn")
var OfferData = preload("res://scripts/OfferData.gd").new()
var F = preload("res://Functional.gd")

signal slime_sold
var list

func _ready():
	list = $ScrollContainer/VBoxContainer
	var color_fn = funcref(self, "slime_of_color")
	
	refill_offers(5)

func any_slime(slime):
	return true

func slime_of_color(min_color, max_color, slime):
	var c = slime.color
	if c.r < min_color.r or c.r > max_color.r:
		return false
	if c.b < min_color.b or c.b > max_color.b:
		return false
	if c.g < min_color.g or c.g > max_color.g:
		return false
	if c.a < min_color.a or c.a > max_color.a:
		return false
	return true

func duplicate_offers():
	for offer in $ScrollContainer/VBoxContainer.get_children():
		add_offer(offer.description, offer.value, offer.condition, offer.side_effect)
	return true

func add_offer(description, value, evaluator, side_effect = null):
	print(evaluator)
	var o = Offer.instance()
	o.init(description, value, evaluator, side_effect)
	list.add_child(o)
	list.queue_sort()
	$ScrollContainer.queue_sort()
	o.connect("slime_sold", self, "_on_slime_sold", [o])

func refill_offers(limit):
	print($ScrollContainer/VBoxContainer.get_children())
	while len($ScrollContainer/VBoxContainer.get_children()) < limit:
		var p = OfferData.get_random_offer_template()
		add_offer(p.description, p.value, p.condition, p.side_effect)

func _on_slime_sold(slime, offer):
	emit_signal("slime_sold", slime, offer.value, offer)

#func _process(delta):
#	pass

# Ideas:

func red_slime(slime):
	var c = slime.color
	print(c)
	return c.r > 0.5 and c.g < 0.1 and c.b < 0.1 and c.a > 0.1

# 1 of any kind
# 1 color range
# 1 very specific color

# 1 opaque
# 1 see-trough
# 1 invisible

# multiple of any kind
# one of multiple kind
# many of many kind

# Specific texts:

#Bring me a red slime.
#Bring me a blue slime.
#Black one for the king of darkness.
#Pink! Pink!

#I want a grey slime, I pay good money for it.

#I want a see-trough slime.
#I want an invisible slime, I misplaced my last one.

#I would like a really large one.

#two red slimes.
#A red and a plue one.

#4 of any kind, please.
