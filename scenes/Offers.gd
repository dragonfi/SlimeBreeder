extends Node2D

var Offer = preload("res://scenes/Offer.tscn")

signal slime_sold
var list

func _ready():
	list = $ScrollContainer/VBoxContainer

	for i in range(5):
		add_offer("Please bring me a slime", 10, funcref(self, "any_slime"))
	add_offer("duplicate all offers (any slime)", 0, funcref(self, "duplicate_offers"))

func any_slime(slime):
	return true

func duplicate_offers(slime):
	for offer in $ScrollContainer/VBoxContainer.get_children():
		print(offer)
		add_offer(offer.description, offer.value, offer.evaluator)
	return true

func add_offer(description, value, evaluator):
	print(evaluator)
	var o = Offer.instance()
	o.init(description, value, evaluator)
	list.add_child(o)
	list.queue_sort()
	$ScrollContainer.queue_sort()
	o.connect("slime_sold", self, "_on_slime_sold", [o])

func _on_slime_sold(slime, offer):
	emit_signal("slime_sold", slime, offer.value, offer)

#func _process(delta):
#	pass
