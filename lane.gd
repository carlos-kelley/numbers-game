class_name Lane
extends Area2D


var cards: Array[Card] = []


func add_card(card: Card) -> void:
	cards.append(card)
	add_child(card)


func remove_card(card: Card) -> void:
	if card in cards:
		cards.erase(card)
		card.queue_free()


func contains_card(card: Card) -> bool:
	return card in cards
