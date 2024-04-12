class_name CardManager
extends Node

const CARD_SPACING: int = 90  # Horizontal spacing between cards


static func generate_cards(player: Player) -> Array:
	print("Generating cards for " + player.name)
	for card: Card in player.cards:
		card.queue_free()  # Remove existing cards if any

	player.cards.clear()

	for i: int in range(6):
		# Initialize card with random value
		var value: int = randi() % 10
		var card_instance: Card = Card.new()

		# Set card properties
		card_instance.value = value
		card_instance.name = "Card" + str(i + 1)

		if player.name == "Player1":
			print("In if for Player1")
			card_instance.start_position = Vector2(100 + i * CARD_SPACING, 1050)
			print("Card start position: " + str(card_instance.start_position))
			card_instance.position = card_instance.start_position
		else:
			card_instance.start_position = Vector2(100 + i * CARD_SPACING, 100)
			card_instance.position = card_instance.start_position

		player.cards.append(card_instance)
		player.add_child(card_instance)
		# print the player's children
		print("Children are", player.get_children())

	return player.cards
