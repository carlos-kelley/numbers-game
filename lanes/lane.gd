class_name Lane
extends Area2D

var cards: Array[Card] = []
var total: int = 0


func add_card(card: Card) -> void:
	print("Adding card to lane")
	cards.append(card)
	add_child(card)
	calculate_total()


func remove_card(card: Card) -> void:
	if card in cards:
		cards.erase(card)
		card.queue_free()
	calculate_total()


func calculate_total() -> void:
	total = 0
	for card: Card in cards:
		total += card.value


func contains_card(card: Card) -> bool:
	return card in cards
