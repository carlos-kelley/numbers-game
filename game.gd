extends Node2D

var CardManager = load("res://card_manager.gd").new()

var ADJECTIVES: Array[String] = ["Fast", "Strong", "Smart", "Dumb", "Easy", "Poopy"]
var CARD_SPACING: int = 90  # Horizontal spacing between cards
const LANE1_POSITION: Vector2 = Vector2(400, 300)
const LANE2_POSITION: Vector2 = Vector2(800, 300)

var currentPlayer: String = "Player1"
var selectedCard: Node = null

var player1_cards = []
var player2_cards = []
var player1_adjectives = []
var player2_adjectives = []


func _ready():
	randomize()
	prepare_players()

	# Connect the card_dropped signal
	for card in get_tree().get_nodes_in_group("Player1_cards"):
		card.connect("card_dropped", self._on_card_dropped)
	for card in get_tree().get_nodes_in_group("Player2_cards"):
		card.connect("card_dropped", self._on_card_dropped)

	print("Game started. Current player is: ", currentPlayer)


func prepare_players():
	for player in ["Player1", "Player2"]:
		var player_node = get_node(player)
		var cards = CardManager.generate_cards(player, player_node)
		var adjectives = CardManager.generate_adjectives(player)

		if player == "Player1":
			player1_cards = cards
			player1_adjectives = adjectives
		else:
			player2_cards = cards
			player2_adjectives = adjectives


# TODO: Cards must be associated with player
func _on_card_dropped(card_node):
	if collide_card_with_lane(card_node.get_node("CardArea"), $Field/P1Lane1):
		if currentPlayer == "Player2":
			print("Not Player 2's lane")
			# Move the card back to the player's hand
			card_node.position = card_node.start_position
		else:
			print("Card dropped in P1 Lane 1")
			card_node.is_draggable = false
			card_node.remove_from_group(currentPlayer + "_cards")
			card_node.add_to_group("P1Lane1_cards")
			var p1_lane1_total = calculate_lane_total("P1Lane1")
			print("Total value of cards in P1 Lane 1: ", p1_lane1_total)
			currentPlayer = "Player2"

	if collide_card_with_lane(card_node.get_node("CardArea"), $Field/P1Lane2):
		if currentPlayer == "Player2":
			print("Not Player 2's lane")
			# Move the card back to the player's hand
			card_node.position = card_node.start_position
		else:
			print("Card dropped in P1 Lane 2")
			card_node.is_draggable = false
			card_node.remove_from_group(currentPlayer + "_cards")
			card_node.add_to_group("P1Lane2_cards")
			var p1_lane2_total = calculate_lane_total("P1Lane2")
			print("Total value of cards in P1 Lane 2: ", p1_lane2_total)
			currentPlayer = "Player2"

	if collide_card_with_lane(card_node.get_node("CardArea"), $Field/P2Lane1):
		if currentPlayer == "Player1":
			print("Not Player 1's lane")
			# Move the card back to the player's hand
			card_node.position = card_node.start_position
		else:
			print("Card dropped in P2 Lane 1")
			card_node.is_draggable = false
			card_node.remove_from_group(currentPlayer + "_cards")
			card_node.add_to_group("P2Lane1_cards")
			var p2_lane1_total = calculate_lane_total("P2Lane1")
			print("Total value of cards in P2 Lane 1: ", p2_lane1_total)
			currentPlayer = "Player1"

	if collide_card_with_lane(card_node.get_node("CardArea"), $Field/P2Lane2):
		if currentPlayer == "Player1":
			print("Not Player 1's lane")
			# Move the card back to the player's hand
			card_node.position = card_node.start_position
		else:
			print("Card dropped in P2 Lane 2")
			card_node.is_draggable = false
			card_node.remove_from_group(currentPlayer + "_cards")
			card_node.add_to_group("P2Lane2_cards")
			var p2_lane2_total = calculate_lane_total("P2Lane2")
			print("Total value of cards in P2 Lane 2: ", p2_lane2_total)
			currentPlayer = "Player1"

	if (
		get_tree().get_nodes_in_group("Player1_cards").size() == 0
		and get_tree().get_nodes_in_group("Player2_cards").size() == 0
	):
		check_game_over()
		# TODO: disallow all card dragging


func calculate_lane_total(lane):
	var total = 0
	for card in get_tree().get_nodes_in_group(lane + "_cards"):
		total += card.number  # Assuming the card's value is stored in the 'number' property
	return total


func collide_card_with_lane(card_area, lane_area):
	print("In collide_card_with_lane")
	return card_area.overlaps_area(lane_area)

func _on_card_clicked(card_node):
	# Store the selected card
	selectedCard = card_node


func check_game_over():
	if (
		get_tree().get_nodes_in_group("Player1_cards").size() == 0
		and get_tree().get_nodes_in_group("Player2_cards").size() == 0
	):
		print("Game Over")
		# Additional logic to disallow all card dragging

		var p1_lane1_total = calculate_lane_total("P1Lane1")
		var p1_lane2_total = calculate_lane_total("P1Lane2")
		var p2_lane1_total = calculate_lane_total("P2Lane1")
		var p2_lane2_total = calculate_lane_total("P2Lane2")

		var p1_total = p1_lane1_total + p1_lane2_total
		var p2_total = p2_lane1_total + p2_lane2_total

		if p1_total > p2_total:
			print("Player 1 wins!")
		elif p1_total < p2_total:
			print("Player 2 wins!")
		else:
			print("It's a draw!")
