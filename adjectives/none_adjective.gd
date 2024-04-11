class_name NoneAdjective
extends Adjective

func _init():
	adj_name = "None"
	adj_description = "No adjective"
	adj_effect = NoneEffect.new()
	adj_scope = NoneScope.new()
#
#
#func apply_effect(card: Node2D, game: Node2D) -> void:
	#pass
