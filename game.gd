extends Node2D

var adjectives = ["Fast", "Strong", "Smart", "Dumb", "Easy", "Poopy"]
var player1_cards = []
var player2_cards = []
var player1_adjectives = []  # Store Player1's adjectives
var player2_adjectives = []  # Store Player2's adjectives
var card_spacing = 150  # Horizontal spacing between cards
var currentPlayer = "Player1"

var selectedCard: Node = null

var lane1_position = Vector2(400, 300)
var lane2_position = Vector2(800, 300)

func _ready():
	randomize()
	generate_cards("Player1")
	generate_cards("Player2")
	generate_adjectives("Player1")
	generate_adjectives("Player2")

	# Connect the card_dropped signal
	for card in get_tree().get_nodes_in_group("cards"):
		card.connect("card_dropped", self._on_card_dropped)

func _on_card_dropped(card_node):
	if collide_card_with_lane(card_node.get_node("CardArea"), $Field/P1Lane1):
		print("Card dropped in Lane 1")
		move_card_to_lane(card_node, lane1_position)

	# Check collision with lane 2
	if collide_card_with_lane(card_node.get_node("CardArea"), $Field/P1Lane2):
		print("Card dropped in Lane 2")
		move_card_to_lane(card_node, lane2_position)

func collide_card_with_lane(card_area, lane_area):
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
		var number:int = randi() % 10
		var adjective = adjectives[randi() % adjectives.size()]
		cards.append({"number": number, "adjective": adjective})

		var card_instance = load("res://Card.tscn").instantiate()

		card_instance.number = number  # Set the number to be displayed
		card_instance.name = "Card" + str(i + 1)

		# Add the card to the "cards" group
		card_instance.add_to_group("cards")  # <-- This line ensures the card is in the group

		# Set the position based on the player's turn and card index
		if player == "Player1":
			card_instance.position = Vector2(100 + i * card_spacing, 600)
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
	# Offset based on current player
	var offset = 50  # Change this value to adjust the separation distance
	var position_offset = Vector2(-offset, 0) if currentPlayer == "Player1" else Vector2(offset, 0)

	# Move the selected card to the chosen lane with the offset
	card_node.position = lane_position + position_offset

	# Switch the current player after a card is chosen
	if currentPlayer == "Player1":
		currentPlayer = "Player2"
	else:
		currentPlayer = "Player1"


	# Check for game over condition here if needed
	if player1_cards.size() == 0 and player2_cards.size() == 0:
		print("Game Over")

