class_name AdjectiveManager
extends Node

var adjectives: Array = [Jealous]

@onready var game = GameManager.get_target_node()


func generate_adjectives() -> Array:
	print("Generating adjectives")
	# Actually create instances of the adjectives
	var random_adjectives: Array = []
	for i: int in range(adjectives.size()):
		var adjective_instance: Adjective = adjectives[i].new()
		random_adjectives.append(adjective_instance)
	print("Generated adjs: ", random_adjectives)
	return random_adjectives
