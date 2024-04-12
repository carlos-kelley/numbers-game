# Makes this script static
class_name GameLogic

extends Node2D

signal game_over

@onready var player_1: Player = $P1
@onready var player_2: Player = $P2

@onready var current_player: Player = player_1
# var valid_player_for_lane: Dictionary = {
# 	P1Lane1: player_1, P1Lane2: player_1, P2Lane1: player_2, P2Lane2: player_2
# }
var total: int = 0
var turn: int = 0
# Get all lanes in scene
@onready var lanes: Array[Node] = get_node("Field").get_children().filter(
	func(lane: Lane) -> bool: return lane is Lane
)


func _ready() -> void:
	prepare_players()
	connect_card_signals()
	print("Game started. Current player is: ", current_player)


func prepare_players() -> void:
	player_1.lanes = [$Field/P1Lane1, $Field/P1Lane2]
	player_2.lanes = [$Field/P2Lane1, $Field/P2Lane2]
	print("P1 Lanes ", player_1.lanes)

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
		handle_card_placement(card, area)
		turn += 1
		print("Turn: ", turn)
		# print("Total value of cards in", area.name, ":", calculate_lane_total(area.name))
		switch_player()
		check_game_over()
		return

	# If the card was not dropped in any lane, return it to its start position
	card.position = card.start_position


func handle_card_placement(card: Card, lane: Lane) -> void:
	card.is_draggable = false
	card.remove_child(card)
	lane.add_card(card)


func switch_player() -> void:
	if current_player == player_1:
		current_player = player_2
	else:
		current_player = player_1


func check_game_over() -> void:
	if turn == 12:
		var e: Error = emit_signal("game_over")
		if e != OK:
			print("Failed to emit signal, error code: ", e)
		print("Game Over")
		# disable_all_dragging()
		announce_winner()


# func disable_all_dragging():
# 	var cards = get_tree().get_nodes_in_group("cards")
# 	for card in cards:
# 		card.set_draggable(false)


func calculate_player_total(player: Player) -> int:
	var total = 0

	for lane: Lane in player.lanes:
		print("Lane: ", lane.name)
		total += lane.total
		print("Total: ", total)

	return total


func announce_winner() -> void:
	var player_1_total: int = calculate_player_total(player_1)
	var player_2_total: int = calculate_player_total(player_2)
	if player_1_total > player_2_total:
		print("Player 1 wins with a total of ", player_1_total)
	elif player_2_total > player_1_total:
		print("Player 2 wins with a total of ", player_2_total)
	else:
		print("It's a tie with a total of ", player_1_total)
