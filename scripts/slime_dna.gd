extends Node

# red - dominant, recessive, inhibitor 

# generate_pigments - HEAVILY_PIGMENTED, SLIGHTLY_PIGMENTED, NO_PIGMENTS
# generate_pigments_inhibitor - INHIBIT_ALL_PIGMENTS, PIGMENTS

# gene/allele types:
# - generates enough protein that enables phenotype (need 1 for 100% effect)
# - generate protein that reinforces phenotype (need 2 for full effect 1 for 50%)
# - generates protein that inhibits phenotype
# - genetares protein that partially inhibits phenotype
# - generates precursor protein, enables expression of another gene
# - generates precursor protein, enables expression of another gene (50% * 2 = 100%)

static func random_choice(seq):
	return seq[randi() % len(seq)]

enum Alleles {
	NONE,
	CYAN,
	MAGENTA,
	YELLOW,
	OPAQUE
}

class Gene:
	var a1
	var a2

	func init(in_a1, in_a2):
		a1 = in_a1
		a2 = in_a2

	func as_float(allele = null):
		if allele == null:
			return (0.5 if a1 != NONE else 0.0) + (0.5 if a2 != NONE else 0.0)
		return (0.5 if a1 == allele else 0.0) + (0.5 if a2 == allele else 0.0) 

	func as_bool(allele = null):
		if allele == null:
			return a1 != NONE or a2 != NONE
		return a1 == allele or a2 == allele
	
	func combine(other):
		var new_gene = get_script().new()
		new_gene.a1 = a1 if randi() % 2 == 0 else other.a1
		new_gene.a2 = a2 if randi() % 2 == 0 else other.a2
		return new_gene

static func g(a1, a2):
	var gene = Gene.new()
	gene.init(a1, a2)
	return gene

static func g_random(alleles):
	return g(random_choice(alleles), random_choice(alleles))

# VERY EASY: single gene, many allotropes
# EASY: mendelian inheritance, multiple genes
# NORMAL: inhibitors, precursors, multiple alleles, etc.

var hex_dna = "v0:"
var bool_dna = [true, false, false, true]
var dna = {
	cyan = g(CYAN, NONE),
	magenta = g(NONE, NONE),
	yellow = g(YELLOW, YELLOW),
	opaque = g(OPAQUE, NONE)
}

export var color = Color(1, 1, 1, 1)
var size = 1.0
var idle_speed = 1.0

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	color = _get_color_from_dna(dna)

func init(input_dna):
	dna = dna

static func get_color(dna):
	var cyan = dna.cyan.as_float()
	var yellow = dna.yellow.as_float()
	var magenta = dna.magenta.as_float()
	var opaqueness = dna.opaque.as_float()

	var red = 1 - cyan
	var green = 1 - magenta
	var blue = 1 - yellow
	var alpha = opaqueness
	return Color(red, green, blue, alpha)

static func random_dna():
	return {
		cyan = g_random([CYAN, NONE]),
		magenta = g_random([MAGENTA, NONE]),
		yellow = g_random([YELLOW, NONE]),
		opaque = g_random([OPAQUE, NONE])
	}

static func combine_dna(dna1, dna2):
	var new_dna = {}
	for key in dna1.keys():
		new_dna[key] = dna1[key].combine(dna2[key])
	return new_dna

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
