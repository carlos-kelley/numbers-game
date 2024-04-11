extends Node2D

# Makes this script static?
class_name GameLogic

var resource_loader = preload("res://resource_loader.gd").new()

signal game_over

# Loads in lane nodes when ready
@onready var lanes = {
	"P1Lane1": $Field/P1Lane1,
	"P1Lane2": $Field/P1Lane2,
	"P2Lane1": $Field/P2Lane1,
	"P2Lane2": $Field/P2Lane2,
}
var CardManager = load("res://card_manager.gd").new()
var currentPlayer: String = "Player1"

# Redundant?
var player1_cards = []
var player2_cards = []
var player1_adjectives = []
var player2_adjectives = []

const PLAYERS: Array[String] = ["Player1", "Player2"]
const OPPONENT = {"Player1": "Player2", "Player2": "Player1"}
const VALID_PLAYER_FOR_LANE = {
	"P1Lane1": "Player1", "P1Lane2": "Player1", "P2Lane1": "Player2", "P2Lane2": "Player2"
}


func _ready():
	randomize()
	prepare_players()
	connect_card_signals()
	print("Game started. Current player is: ", currentPlayer)


func prepare_players():
	for player in PLAYERS:
		var player_node = get_node(player)
		var cards = CardManager.generate_cards(player, player_node)

		if player == "Player1":
			player1_cards = cards

		else:
			player2_cards = cards


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
			if currentPlayer != VALID_PLAYER_FOR_LANE[lane]:
				print("Not", VALID_PLAYER_FOR_LANE[lane], "'s lane")
				card_node.position = card_node.start_position
				return
			print("Card dropped in", lane)
			handle_card_placement(card_node, lane)
			print("Total value of cards in", lane, ":", calculate_lane_total(lane))
			currentPlayer = OPPONENT[currentPlayer]  # Switch player
			check_game_over()
			return

	print("Card dropped in an invalid area")  # Handle case where no collision is detected with any lane
	card_node.position = card_node.start_position


func handle_card_placement(card_node, lane):
	card_node.is_draggable = false
	card_node.remove_from_group(currentPlayer + "_cards")
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
