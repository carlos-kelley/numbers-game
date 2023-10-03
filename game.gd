extends Node2D

var adjectives = ["Fast", "Strong", "Smart"]
var player1_cards = []
var player2_cards = []

func _ready():
	randomize()  # Initialize random seed
	generate_cards("Player1")
	generate_cards("Player2")
	play_turn("Player1")

func generate_cards(player):
	var player_node = get_node(player)
	for child in player_node.get_children():
		child.queue_free()  # Remove existing cards if any
	
	var cards = []
	for i in range(3):
		var number:int = randi() % 10
		var adjective = adjectives[randi() % adjectives.size()]
		cards.append({"number": number, "adjective": adjective})
		
		var card_instance = load("res://Card.tscn").instantiate();
		card_instance.number = number  # Set the number to be displayed
		card_instance.name = "Card" + str(i + 1)

		# Set the position to the center of the screen
		card_instance.position = get_viewport_rect().size / 2

		player_node.add_child(card_instance)
		
	if player == "Player1":
		player1_cards = cards
	else:
		player2_cards = cards

func play_turn(player):
	var card
	if player == "Player1":
		card = player1_cards.pop_front()
	else:
		card = player2_cards.pop_front()
	
	print("Player %s plays card: %s %s" % [player, card["adjective"], card["number"]])
	
	if player1_cards.size() == 0 and player2_cards.size() == 0:
		print("Game Over")
		return
	
	if player == "Player1":
		play_turn("Player2")
	else:
		play_turn("Player1")
