class_name NoneAdjective
extends Adjective


func _init() -> void:
	name = "None"
	description = "No adjective"
	effect = NoneEffect.new()
	scope = NoneScope.new()
#
#
#func apply_effect(card: Node2D, game: Node2D) -> void:
#pass
