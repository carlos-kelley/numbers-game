class_name Jealous
extends Adjective

func _init():
    name = "Jealous"
    description = "Destroy ALL other cards of the same value."

func apply_effect(card: Node2D, game: Node2D) -> void:
    for lane in game.lanes:
        for other_card in lane:
            if other_card != card and other_card.number == card.number:
                other_card.queue_free()  # Destroy the other card