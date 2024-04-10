extends Node2D

var number: int = 0
var radius: int = 30
var in_hand: bool = true
var is_dragging = false
var drag_offset = Vector2()
var font = ThemeDB.fallback_font

signal card_clicked(card_node)
signal card_dropped(card_node)

# Define constants for text drawing
const TEXT_POSITION = Vector2(-12, 13)
const TEXT_ALIGNMENT = HORIZONTAL_ALIGNMENT_CENTER
const TEXT_MAX_WIDTH = -1
const TEXT_SIZE = 40
const TEXT_COLOR = Color(1, 1, 1, 1)


func _input(event):
	if not in_hand:
		return

	var mouse_pos = get_global_mouse_position()

	# Check if mouse is within the card's radius
	# These two events are apparently firing alternately
	if event is InputEventMouseButton and mouse_pos.distance_to(global_position) <= radius:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				print("Is dragging.")
				is_dragging = true
				drag_offset = mouse_pos - global_position
			else:
				print("Not dragging.")
				is_dragging = false
				emit_signal("card_dropped", self)

	elif event is InputEventMouseMotion and is_dragging:
		global_position = event.global_position - drag_offset


func _draw():
	draw_circle(Vector2(0, 0), radius, Color(1, 0, 0, 1))

	draw_string(
		font, TEXT_POSITION, str(number), TEXT_ALIGNMENT, TEXT_MAX_WIDTH, TEXT_SIZE, TEXT_COLOR
	)
