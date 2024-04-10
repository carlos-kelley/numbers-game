extends Node2D

var adjectives = ["Fast", "Strong", "Smart", "Dumb", "Easy", "Poopy"]
var player1_cards = []
var player2_cards = []
var player1_adjectives = []
var player2_adjectives = []
var card_spacing = 90  # Horizontal spacing between cards
var currentPlayer = "Player1"


var selectedCard: Node = null

const LANE1_POSITION = Vector2(400, 300)
const LANE2_POSITION = Vector2(800, 300)


func _ready():
	randomize()
	generate_cards("Player1")
	generate_cards("Player2")
	generate_adjectives("Player1")
	generate_adjectives("Player2")

	# Connect the card_dropped signal
	for card in get_tree().get_nodes_in_group("cards"):
		card.connect("card_dropped", self._on_card_dropped)

	print("Game started. Current player is: ", currentPlayer)

# TODO: Cards must be associated with player
func _on_card_dropped(card_node):
	if collide_card_with_lane(card_node.get_node("CardArea"), $Field/P1Lane1):
		if currentPlayer == "Player2":
			print ("Not Player 2's lane")
		else:
			print("Card dropped in P1 Lane 1")
			currentPlayer = "Player2"

	if collide_card_with_lane(card_node.get_node("CardArea"), $Field/P1Lane2):
		if currentPlayer == "Player2":
			print ("Not Player 2's lane")
		else:
			print("Card dropped in P1 Lane 2")
			currentPlayer = "Player2"

	if collide_card_with_lane(card_node.get_node("CardArea"), $Field/P2Lane1):
		if currentPlayer == "Player1":
			print ("Not Player 1's lane")
		else:
			print("Card dropped in P2 Lane 1")
			currentPlayer = "Player1"

	if collide_card_with_lane(card_node.get_node("CardArea"), $Field/P2Lane2):
		if currentPlayer == "Player1":
			print ("Not Player 1's lane")
		else:
			print("Card dropped in P2 Lane 2")
			currentPlayer = "Player1"


func collide_card_with_lane(card_area, lane_area):
	print("In collide_card_with_lane")
	return card_area.overlaps_area(lane_area)


func generate_adjectives(player):
	var player_adjectives = []

	adjectives.shuffle()  # Shuffle the array to ensure randomness
	for i in range(3):
		var adjective = adjectives.pop_front()  # Take and remove the first adjective
		player_adjectives.append(adjective)

	if player == "Player1":
		player1_adjectives = player_adjectives
	else:
		player2_adjectives = player_adjectives


func generate_cards(player):
	var player_node = get_node(player)
	for child in player_node.get_children():
		child.queue_free()  # Remove existing cards if any

	var cards = []
	for i in range(6):
		print("Generating card ", i + 1)
		# Generate a random number between 0 and 9 and select a random adjective
		var number: int = randi() % 10
		print ("Number: ", number)
		var adjective = adjectives[randi() % adjectives.size()]
		print ("Adjective: ", adjective)
		# cards.append({"number": number, "adjective": adjective, "player": player})
		print ("Cards: ", cards)

		var card_instance = load("res://Card.tscn").instantiate()

		card_instance.number = number
		card_instance.adjective = adjective
		card_instance.player = player
		card_instance.name = "Card" + str(i + 1)

		# Add the card to the "cards" group
		# TODO: Currently missing P2 Card6
		card_instance.add_to_group("cards")
		# Log the "cards" group
		print("Cards group:", get_tree().get_nodes_in_group("cards"))
		# Set the position based on the player's turn and card index
		if player == "Player1":
			card_instance.position = Vector2(100 + i * card_spacing, 1050)
		else:
			card_instance.position = Vector2(100 + i * card_spacing, 100)

		player_node.add_child(card_instance)
		card_instance.connect("card_clicked", self._on_card_clicked)

	if player == "Player1":
		player1_cards = cards
	else:
		player2_cards = cards


func _on_card_clicked(card_node):
	# Store the selected card
	selectedCard = card_node


func move_card_to_lane(card_node, lane_position):
	# Switch the current player after a card is chosen
	if currentPlayer == "Player1":
		currentPlayer = "Player2"
		print("Player 1 has played a card")
	else:
		currentPlayer = "Player1"
		print("Player not changed")

	if player1_cards.size() == 0 and player2_cards.size() == 0:
		print("Game Over")
