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
		var adjective_scene := preload("res://Adjective.tscn").instantiate()
		adjective_instance.start_position = Vector2(50 + i * ADJECTIVE_SPACING, 525)
		adjective_instance.position = adjective_instance.start_position

		game.add_child(adjective_instance)
		adjective_instance.add_child(adjective_scene)
		#Set the label's text to the adjective name
		var adjective_label: Label = adjective_scene.get_child(0) as Label

		print("Adjective label: ", adjective_label)
		adjective_label.text = adjective_instance.name
		random_adjectives.append(adjective_instance)
	print("Generated adjs: ", random_adjectives)
	return random_adjectives
