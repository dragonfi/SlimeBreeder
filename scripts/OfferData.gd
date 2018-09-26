extends Reference

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
class Interval extends Reference:
	var _min = null
	var _max = null

	func _init(minimum, maximum):
		_min = minimum
		_max = maximum
	
	func contains(number):
		return (_min == null or _min <= number) and (_max == null or _max >= number)

class ColorInterval extends Reference:
	var r
	var g
	var b
	var a
	
	func _init(_r, _g, _b, _a):
		r = _convert_arg(_r)
		g = _convert_arg(_g)
		b = _convert_arg(_b)
		a = _convert_arg(_a)
	
	func contains(color):
		return r.contains(color.r) and g.contains(color.g) and b.contains(color.b) and a.contains(color.a)

	func _convert_arg(arg):
		match arg:
			Interval:
				return arg
			[var first, var second]:
				return Interval.new(first, second)
			_:
				print("arg should be either an Interval or an array with 2 items")
				return arg

class OfferCondition extends Reference:
	func _init():
		pass
	
	func is_fulfilled_by(slime):
		return true

class AnySlimeCondition extends OfferCondition:
	func _init().():
		pass

class RgbaCondition extends OfferCondition:
	var color_interval
	
	func _init(r, g, b, a).():
		color_interval = ColorInterval.new(r, g, b, a)
		
	func is_fulfilled_by(slime):
		return color_interval.contains(slime.color)

class GreyCondition extends OfferCondition:
	func _init().():
		pass
	
	func is_fulfilled_by(slime):
		var c = slime.color
		return c.r == c.g and c.g == c.b

class AllMultiOffer extends OfferCondition:
	var offers

	func _init(_offers).():
		offers = _offers
	
	func is_fulfilled_by(slime):
		for offer in offers:
			if not offer.is_fulfilled_by(slime):
				return false
		return true

var offer_templates

func _init():
	offer_templates = [
		["Bring me a red slime.", 100, RgbaCondition.new([0.5, 1.0], [0.0, 0.2], [0.0, 0.2], [0.5, 1.0]), null],
		["Bring me a green slime.", 100, RgbaCondition.new([0.0, 0.2], [0.5, 1.0], [0.0, 0.2], [0.5, 1.0]), null],
		["Bring me a blue slime.", 100, RgbaCondition.new([0.0, 0.4], [0.0, 0.4], [0.5, 1.0], [0.5, 1.0]), null],
		["Bring me a purple slime.", 200, RgbaCondition.new([0.5, 1.0], [0.0, 0.2], [0.5, 1.0], [0.5, 1.0]), null],
		["Bring me a yellow slime.", 200, RgbaCondition.new([0.5, 1.0], [0.5, 1.0], [0.0, 0.2], [0.5, 1.0]), null],
		["Bring me a transparent slime.", 300, RgbaCondition.new([0.0, 1.0], [0.0, 1.0], [0.0, 1.0], [0.0, 0.5]), null],
		["I want a fully opaque slime.", 200, RgbaCondition.new([0.0, 1.0], [0.0, 1.0], [0.0, 1.0], [1.0, 1.0]), null],
		["I want a fully transparent slime.", 500, RgbaCondition.new([0.0, 1.0], [0.0, 1.0], [0.0, 1.0], [0.0, 0.0]), null],
		["I want a perfect red slime.", 500, RgbaCondition.new([1.0, 1.0], [0.0, 0.0], [0.0, 0.0], [1.0, 1.0]), null],
		["I want an albino slime.", 1000, RgbaCondition.new([1.0, 1.0], [1.0, 1.0], [1.0, 1.0], [0.0, 1.0]), null],
		["I need a grey slime, don't care about anything else.", 1000, GreyCondition.new(), null],
		["I want to buy a slime, any kind of slime.", 10, AnySlimeCondition.new(), null],
		["Give me a fully black slime. It should ooze of emo.", 300, RgbaCondition.new([0.0, 0.0], [0.0, 0.0], [0.0, 0.0], [0.0, 1.0]), null],
		[
			"It should be grey, but neither too dark, nor light. Also, I don't like see-trough.",
			1000,
			AllMultiOffer.new([
				GreyCondition.new(),
				RgbaCondition.new([0.2, 0.8], [0.2, 0.8], [0.2, 0.8], [1.0, 1.0])
			]),
			null
		],
			
	]

class OfferParameters:
	var description
	var value
	var condition
	var side_effect

	func _init(array):
		description = array[0]
		value = array[1]
		condition = array[2]
		side_effect = array[3]

func random_choice(items):
	return items[randi() % len(items)]

func get_random_offer_template():
	return OfferParameters.new(random_choice(offer_templates))

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
