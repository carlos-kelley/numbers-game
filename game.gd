# Makes this script static
class_name GameLogic

extends Node2D

signal game_over

@onready var player_1: Player = $P1
@onready var player_2: Player = $P2
var opponent: Dictionary = {player_1: player_2, player_2: player_1}
@onready var current_player: Player = player_1
# var valid_player_for_lane: Dictionary = {
# 	P1Lane1: player_1, P1Lane2: player_1, P2Lane1: player_2, P2Lane2: player_2
# }

# Loads in lane nodes when ready
# @onready var lanes: Dictionary = {
# 	"P1Lane1": $Field/P1Lane1,
# 	"P1Lane2": $Field/P1Lane2,
# 	"P2Lane1": $Field/P2Lane1,
# 	"P2Lane2": $Field/P2Lane2,
# }


func _ready() -> void:
	prepare_players()
	connect_card_signals()
	print("Game started. Current player is: ", current_player)


func prepare_players() -> void:
	# Get the player nodes and give them cards
	for player: Player in [player_1, player_2]:
		print("Is Player in tree?: ", player.is_inside_tree())
		var cards: Array[Card] = CardManager.generate_cards(player)
		player.cards = cards
		print(player.name, "has cards ", player.cards)


func connect_card_signals() -> void:
	for player: Player in [player_1, player_2]:
		for card: Card in player.cards:
			var e: Error = card.connect("card_dropped", _on_card_dropped)
			if e != OK:
				print("Failed to connect signal, error code: ", e)


# Instance that emits the signal is automatically passed as first argument
func _on_card_dropped(card: Card) -> void:
	print("Card dropped")
	var overlapping_areas = card.get_overlapping_areas()
	print("Overlapping areas: ", overlapping_areas)

	for area: Lane in overlapping_areas:
		# if area in lanes
		print("Card dropped in", area.name)
		handle_card_placement(card, area.name)
		print("Total value of cards in", area.name, ":", calculate_lane_total(area.name))
		current_player = opponent[current_player]  # Switch player
		return

	# If the card was not dropped in any lane, return it to its start position
	card.position = card.start_position


func handle_card_placement(card, lane):
	card.is_draggable = false
	# card_node.remove_from_group(current_player + "_cards")
	card.add_to_group(lane + "_cards")


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
