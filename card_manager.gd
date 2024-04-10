extends Node

var ADJECTIVES: Array[String] = ["Fast", "Strong", "Smart", "Dumb", "Easy", "Poopy"]
var CARD_SPACING: int = 90  # Horizontal spacing between cards

func generate_adjectives(player: String):
    var adjectives = ADJECTIVES.duplicate()
    adjectives.shuffle()
    var selected_adjectives = adjectives.slice(0, 2)  # Select three random adjectives, current test
    return selected_adjectives

func generate_cards(player, player_node):
    for child in player_node.get_children():
        child.queue_free()  # Remove existing cards if any

    var cards = []
    for i in range(6):
        var number: int = randi() % 10
        var adjective = ADJECTIVES[randi() % ADJECTIVES.size()]

        var card_instance = load("res://Card.tscn").instantiate()

        card_instance.number = number
        card_instance.adjective = adjective
        card_instance.player = player
        card_instance.name = "Card" + str(i + 1)

        if player == "Player1":
            card_instance.start_position = Vector2(100 + i * CARD_SPACING, 1050)
        else:
            card_instance.start_position = Vector2(100 + i * CARD_SPACING, 100)
            card_instance.position = card_instance.start_position

        card_instance.add_to_group(player + "_cards")

        if player == "Player1":
            card_instance.position = Vector2(100 + i * CARD_SPACING, 1050)
        else:
            card_instance.position = Vector2(100 + i * CARD_SPACING, 100)

        player_node.add_child(card_instance)
        cards.append(card_instance)

    return cards