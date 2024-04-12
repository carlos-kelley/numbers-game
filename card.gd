class_name Card
extends Sprite2D

signal card_dropped(card_node)

var texture_paths: Dictionary = {}

# Value has setter so we can update texture when it changes
var _value: int = 0
var value: int:
	set(new_value):
		_value = new_value
		# This texture is from Node2D
		texture = texture_paths[_value]
var is_dragging: bool = false
var drag_offset: Vector2 = Vector2.ZERO
var start_position: Vector2 = Vector2.ZERO
# var font: Font = ThemeDB.fallback_font
var adjective: Adjective = NoneAdjective.new()
var player: String = ""
var is_draggable: bool = true


func _init() -> void:
	print("Card init.")
	for i: int in range(10):
		texture_paths[i] = load("res://images/" + str(i) + ".png")
		print(texture_paths[i])


@onready var game: GameLogic = get_node("/root/Game")


func _ready() -> void:
	print("Card ready.")


func _input(event: InputEvent) -> void:
	# TODO: refactor
	var mouse_pos: Vector2 = get_global_mouse_position()
	if is_draggable == false:
		return

	# Check if mouse is within the card's radius
	# These two events are apparently firing alternately
	if event is InputEventMouseButton:
		if get_rect().has_point(to_local(mouse_pos)):
			if event.button_index == MOUSE_BUTTON_LEFT:
				if event.pressed:
					# Make sure the player of this card is the current player
					var player_of_card: Player = get_parent()
					if player_of_card == game.current_player:
						print("Is dragging.")
						is_dragging = true
						drag_offset = mouse_pos - global_position
				else:
					print("Not dragging.")
					is_dragging = false
					emit_signal("card_dropped", self)

	elif event is InputEventMouseMotion and is_dragging:
		global_position = mouse_pos - drag_offset
