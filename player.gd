extends Node

class_name Player

var cards: Array[Card] = []
var score: int = 0


func _init(player_name: String) -> void:
	self.name = player_name


func add_card(card) -> void:
	cards.append(card)


func remove_card(card) -> void:
	if card in cards:
		cards.erase(card)


func has_card(card) -> Card:
	return card in cards
