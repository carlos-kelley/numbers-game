extends Node2D

@onready var game = get_node("/root/Game")

var number: int = 0
var radius: int = 30
var is_dragging: bool = false
var drag_offset: Vector2 = Vector2.ZERO
var start_position: Vector2 = Vector2.ZERO
var font = ThemeDB.fallback_font
var adjective: String = ""
var player: String = ""

signal card_clicked(card_node)
signal card_dropped(card_node)

# Define constants for text drawing
const TEXT_POSITION: Vector2 = Vector2(-12, 13)
const TEXT_ALIGNMENT: int = HORIZONTAL_ALIGNMENT_CENTER
const TEXT_MAX_WIDTH: int = -1
const TEXT_SIZE: int = 40
const TEXT_COLOR: Color = Color(1, 1, 1, 1)


func _input(event: InputEvent) -> void:
	var mouse_pos: Vector2 = get_global_mouse_position()

	# Check if mouse is within the card's radius
	# These two events are apparently firing alternately
	# TODO: refactor the chain of four ifs and the else
	if event is InputEventMouseButton and mouse_pos.distance_to(global_position) <= radius:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				# Make sure the player of this card is the current player
				if self.player == game.currentPlayer:
					print("Is dragging.")
					is_dragging = true
					drag_offset = mouse_pos - global_position
			else:
				print("Not dragging.")
				is_dragging = false
				emit_signal("card_dropped", self)

	elif event is InputEventMouseMotion and is_dragging:
		global_position = mouse_pos - drag_offset


func _draw() -> void:
	draw_circle(Vector2.ZERO, radius, Color(1, 0, 0, 1))
	draw_string(
		font, TEXT_POSITION, str(number), TEXT_ALIGNMENT, TEXT_MAX_WIDTH, TEXT_SIZE, TEXT_COLOR
	)
