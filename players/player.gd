class_name Player
extends Node

var cards: Array[Card] = []
var score: int = 0
var lanes: Array[Lane] = []


func add_card(card) -> void:
	cards.append(card)


func remove_card(card) -> void:
	if card in cards:
		cards.erase(card)


func has_card(card) -> Card:
	return card in cards
