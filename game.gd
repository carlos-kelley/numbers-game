# Makes this script static
@tool

class_name GameLogic

extends Node2D

signal game_over

var player_1: Player = Player.new("Player1")
var player_2: Player = Player.new("Player2")
var card_manager: CardManager = CardManager.new()

# Loads in lane nodes when ready
@onready var lanes = {
	"P1Lane1": $Field/P1Lane1,
	"P1Lane2": $Field/P1Lane2,
	"P2Lane1": $Field/P2Lane1,
	"P2Lane2": $Field/P2Lane2,
}
# var card_manager = load("res://card_manager.gd").new()
var current_player: Player = player_1

# Redundant?
var player1_cards = []
var player2_cards = []
var player1_adjectives = []
var player2_adjectives = []

var opponent: Dictionary = {player_1: player_2, player_2: player_1}
# var valid_player_for_lane: Dictionary = {
# 	P1Lane1: player_1, P1Lane2: player_1, P2Lane1: player_2, P2Lane2: player_2
# }


func _ready() -> void:
	prepare_players()
	connect_card_signals()
	print("Game started. Current player is: ", current_player)


func prepare_players() -> void:
	# Get the player nodes and give them cards
	for player: Player in [player_1, player_2]:
		add_child(player)
		print("Is Player in tree?: ", player.is_inside_tree())
		var cards: Array[Card] = CardManager.generate_cards(player)
		player.cards = cards
		print(player.name, "has cards ", player.cards)


func connect_card_signals():
	var player_card_groups: Array[String] = ["Player1_cards", "Player2_cards"]
	for group in player_card_groups:
		for card in get_tree().get_nodes_in_group(group):
			card.connect("card_dropped", self._on_card_dropped)


func _on_card_dropped(card_node):
	for lane in lanes:
		var field_path = lanes[lane]
		var card_area = card_node.get_node("CardArea")

		if card_area.overlaps_area(field_path):
			# if current_player != VALID_PLAYER_FOR_LANE[lane]:
			# print("Not", VALID_PLAYER_FOR_LANE[lane], "'s lane")
			# card_node.position = card_node.start_position
			# return
			print("Card dropped in", lane)
			handle_card_placement(card_node, lane)
			print("Total value of cards in", lane, ":", calculate_lane_total(lane))
			current_player = opponent[current_player]  # Switch player
			check_game_over()
			return

	print("Card dropped in an invalid area")  # Handle case where no collision is detected with any lane
	card_node.position = card_node.start_position


func handle_card_placement(card_node, lane):
	card_node.is_draggable = false
	# card_node.remove_from_group(current_player + "_cards")
	card_node.add_to_group(lane + "_cards")


func check_game_over():
	if (
		get_tree().get_nodes_in_group("Player1_cards").size() == 0
		and get_tree().get_nodes_in_group("Player2_cards").size() == 0
	):
		emit_signal("game_over")
		print("Game Over")
		disable_all_dragging()

		var scores = calculate_total_scores()
		announce_winner(scores)


func disable_all_dragging():
	var cards = get_tree().get_nodes_in_group("cards")
	for card in cards:
		card.set_draggable(false)


func calculate_total_scores():
	var player_scores = {"Player1": 0, "Player2": 0}
	var lane_assignments = {"Player1": ["P1Lane1", "P1Lane2"], "Player2": ["P2Lane1", "P2Lane2"]}

	for player in lane_assignments:
		var player_lanes = lane_assignments[player]
		for lane in player_lanes:
			player_scores[player] += calculate_lane_total(lane)

	return player_scores


func calculate_lane_total(lane):
	var total = 0
	var cards = get_tree().get_nodes_in_group(lane + "_cards")
	for card in cards:
		total += card.number  # Assuming 'number' property holds card value
	return total


func announce_winner(scores):
	var p1_total = scores["Player1"]
	var p2_total = scores["Player2"]

	if p1_total > p2_total:
		print("Player 1 wins!")
	elif p1_total < p2_total:
		print("Player 2 wins!")
	else:
		print("It's a draw!")
