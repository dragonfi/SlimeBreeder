extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
signal slime_sold
var Offer = preload("res://scenes/Offer.tscn")
var list

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
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
	o.connect("pressed", self, "_on_offer_pressed", [o])
	o.connect("slime_sold", self, "_on_slime_sold", [o])

func _on_slime_sold(slime, offer):
	emit_signal("slime_sold", slime, offer.value)

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
