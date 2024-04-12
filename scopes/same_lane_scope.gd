class_name SameLaneScope
extends Scope


func get_targets(card: Node2D, game: Node2D) -> Array:
	var targets: Array = []
	for other_card in game.get_children():
		if other_card.lane == card.lane:
			targets.append(other_card)
	return targets
