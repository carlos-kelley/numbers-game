class_name AdjectiveManager
extends Node

var adjectives: Array = [Jealous]

@onready var game = get_parent()
#print tree


func generate_adjectives() -> Array:
	print("Generating adjectives with game", game)
	# Actually create instances of the adjectives
	var random_adjectives: Array = []
	for i: int in range(adjectives.size()):
		var adjective_instance: Adjective = adjectives[i].new()
		# var adjective_scene = preload("res://Adjective.tscn")
		game.add_child(adjective_instance)
		
		# adjective_instance.add_child(adjective_scene)
		random_adjectives.append(adjective_instance)
	print("Generated adjs: ", random_adjectives)
	return random_adjectives
