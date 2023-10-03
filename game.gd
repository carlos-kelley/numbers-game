extends Node2D

var adjectives = ["Fast", "Strong", "Smart", "Dumb", "Easy", "Poopy"]
var player1_cards = []
var player2_cards = []
var player1_adjectives = []  # Store Player1's adjectives
var player2_adjectives = []  # Store Player2's adjectives
var card_spacing = 150  # Adjust this value for horizontal spacing between cards
var currentPlayer = "Player1"  # Initialize with Player1 as the current player

var selectedCard: Node = null  # Store the selected card instance

func _ready():
	randomize()  # Initialize random seed
	generate_cards("Player1")
	generate_cards("Player2")
	generate_adjectives("Player1")
	generate_adjectives("Player2")
	print("P1 Adj", player1_adjectives)
	print("P2 Adj", player2_adjectives)

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
	for i in range(3):
		var number:int = randi() % 10
		var adjective = adjectives[randi() % adjectives.size()]
		cards.append({"number": number, "adjective": adjective})

		var card_instance = load("res://Card.tscn").instantiate()

		card_instance.number = number  # Set the number to be displayed
		card_instance.name = "Card" + str(i + 1)

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
	# Check if the clicked card belongs to the current player
	if (currentPlayer == "Player1" and card_node.get_parent() == get_node("Player1")) or (currentPlayer == "Player2" and card_node.get_parent() == get_node("Player2")):
		card_node.in_hand = false  # Set the card as no longer in the hand
		move_card_to_center(card_node)


func move_card_to_center(card_node):
	# Offset based on current player
	var offset = 50  # Change this value to adjust the separation distance
	var position_offset = Vector2(-offset, 0) if currentPlayer == "Player1" else Vector2(offset, 0)


	# Move the selected card to the center of the screen with the offset
	card_node.position = get_viewport_rect().size / 2 + position_offset

	# Switch the current player after a card is chosen
	if currentPlayer == "Player1":
		currentPlayer = "Player2"
	else:
		currentPlayer = "Player1"

	# Check for game over condition here if needed
	if player1_cards.size() == 0 and player2_cards.size() == 0:
		print("Game Over")

