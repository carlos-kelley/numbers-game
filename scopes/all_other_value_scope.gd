class_name AllOtherValueScope
extends Scope


func get_targets(card: Card, game: GameLogic) -> Array:
	# Get all cards in all lanes with the same value as the card this effect is on
	var targets: Array = []
	for lane: Lane in game.get_node("Field").get_children():
		for target: Card in lane.get_children():
			if target.value == card.value:
				targets.append(target)
	print("Targeting: ", targets)
	return targets
