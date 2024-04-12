extends Node

var ADJECTIVES = [Jealous]


func get_random_adjectives(count: int) -> Array:
	ADJECTIVES.shuffle()
	# Actually create instances of the adjectives
	var random_adjectives = []
	for i in range(count):
		var adjective_instance = ADJECTIVES[i].new()
		random_adjectives.append(adjective_instance)

	return random_adjectives
