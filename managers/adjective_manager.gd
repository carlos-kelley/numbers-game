class_name AdjectiveManager
extends Node

const ADJECTIVE_SPACING = 90
var adjectives: Array = [Jealous]
@onready var game = $"."


func generate_adjectives() -> Array:
	print("Generating adjectives with game", game)
	# Actually create instances of the adjectives
	var random_adjectives: Array = []
	for i: int in range(adjectives.size()):
		var adjective_instance: Adjective = adjectives[i].new()
		adjective_instance.start_position = Vector2(50 + i * ADJECTIVE_SPACING, 525)
		adjective_instance.position = adjective_instance.start_position

		game.add_child(adjective_instance)
		random_adjectives.append(adjective_instance)
	print("Generated adjs: ", random_adjectives)
	return random_adjectives
