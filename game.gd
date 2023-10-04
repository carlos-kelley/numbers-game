extends Node2D

var adjectives = ["Fast", "Strong", "Smart", "Dumb", "Easy", "Poopy"]
var player1_cards = []
var player2_cards = []
var player1_adjectives = []  # Store Player1's adjectives
var player2_adjectives = []  # Store Player2's adjectives
var card_spacing = 150  # Adjust this value for horizontal spacing between cards
var currentPlayer = "Player1"  # Initialize with Player1 as the current player

var selectedCard: Node = null  # Store the selected card instance

var lane1_position = Vector2(400, 300)
var lane2_position = Vector2(800, 300)

func _ready():
	randomize()  # Initialize random seed
	generate_cards("Player1")
	generate_cards("Player2")
	generate_adjectives("Player1")
	generate_adjectives("Player2")
	print("P1 Adj", player1_adjectives)
	print("P2 Adj", player2_adjectives)

	# Connect the card_dropped signal for each card
	for card in get_tree().get_nodes_in_group("cards"): # Make sure your cards are in a group named "cards"
		card.connect("card_dropped", self._on_card_dropped)

func _on_card_dropped(card_node):
	# Check collision with lane 1
	if collide_card_with_lane(card_node, $Lane1Collision):
		print("Card dropped in Lane 1")
		move_card_to_lane(card_node, lane1_position)

	# Check collision with lane 2
	if collide_card_with_lane(card_node, $Lane2Collision):
		print("Card dropped in Lane 2")
		move_card_to_lane(card_node, lane2_position)

func collide_card_with_lane(card, lane_collision):
	var card_radius = card.radius  # Accessing the radius of the card

	var card_shape = card.get_world_2d().direct_space_state.create_convex_polygon([
		card.global_position + Vector2(-card_radius, -card_radius),
		card.global_position + Vector2(card_radius, -card_radius),
		card.global_position + Vector2(card_radius, card_radius),
		card.global_position + Vector2(-card_radius, card_radius)])

	var shape_query = PhysicsShapeQueryParameters2D.new()
	shape_query.shape = card_shape
	shape_query.transform = Transform2D(0, card.global_position)

	var results = get_world_2d().direct_space_state.intersect_shape(shape_query)
	for result in results:
		if result.collider == lane_collision:
			return true

	return false



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

