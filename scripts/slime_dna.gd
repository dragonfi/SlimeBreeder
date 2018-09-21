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
	OPAQUE,
	DOMINANT,
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
	
	func as_dominant(allele = null):
		return 1.0 if as_bool(allele) else 0.0
	
	func _str():
		return "[%s,%s]" % [a1, a2]

	func combine(other):
		var new_gene = get_script().new()
		new_gene.a1 = a1 if randi() % 2 == 0 else a2
		new_gene.a2 = other.a1 if randi() % 2 == 0 else other.a2
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

class Dna:
	var dna = {}
	
	func init(new_dna):
		dna = new_dna
		return self
	
	func get_color():
		var cyan = 0.0
		var yellow = 0.0
		var magenta = 0.0
		var opaqueness = 0.0
	
		if dna.cyan_precursor.as_dominant():
			cyan = 0.5 * dna.cyan1.as_dominant() + 0.5 * dna.cyan2.as_dominant()
		if dna.yellow_precursor.as_dominant():
			yellow = 0.5 * dna.yellow1.as_dominant() + 0.5 * dna.yellow2.as_dominant()
		if dna.magenta_precursor.as_dominant():
			magenta = 0.5 * dna.magenta1.as_dominant() + 0.5 * dna.magenta2.as_dominant()

		opaqueness = 0.5 * dna.opaque1.as_dominant() + 0.5 * dna.opaque2.as_dominant()

		var red = 1 - cyan
		var green = 1 - magenta
		var blue = 1 - yellow
		var alpha = opaqueness
		return Color(red, green, blue, alpha)
	
	func get_size():
		return 1.0

	func get_idle_speed():
		return 1.0

	func combine(other):
		var new_dna = {}
		for key in dna.keys():
			new_dna[key] = dna[key].combine(other.dna[key])
		return get_script().new().init(new_dna)

	func _str():
		var string = ""
		for key in dna:
			string += "%s:%s" % [key, dna[key]._str()]
		return string

static func new_random_dna():
	return Dna.new().init({
		cyan1 = g_random([CYAN, NONE]),
		cyan2 = g_random([CYAN, NONE]),
		magenta1 = g_random([MAGENTA, NONE]),
		magenta2 = g_random([MAGENTA, NONE]),
		yellow1 = g_random([YELLOW, NONE]),
		yellow2 = g_random([YELLOW, NONE]),
		opaque1 = g_random([OPAQUE, NONE]),
		opaque2 = g_random([OPAQUE, NONE]),
		cyan_precursor = g_random([DOMINANT, NONE]),
		magenta_precursor = g_random([DOMINANT, NONE]),
		yellow_precursor = g_random([DOMINANT, NONE]),
	})

#func _process(delta):
#	pass
