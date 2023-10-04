extends Node2D

var number: int = 0  # The number to display
var radius: int = 30  # Radius of the circle
var in_hand: bool = true  # To determine if the card is still in a player's hand
var font = ThemeDB.fallback_font

var is_dragging = false
var drag_offset = Vector2()


signal card_clicked(card_node)
signal card_dropped(card_node)


func _input(event):
	if in_hand:
		if event is InputEventMouseButton:
			var mouse_pos = get_global_mouse_position()
			var distance_to_center = mouse_pos.distance_to(global_position)
			if distance_to_center <= radius:
				if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
					is_dragging = true
					drag_offset = mouse_pos - global_position
				elif not event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
					is_dragging = false
					emit_signal("card_dropped", self)
		elif event is InputEventMouseMotion and is_dragging:
			global_position = event.global_position - drag_offset




func _draw():
	# Draw the circle
	draw_circle(Vector2(0, 0), radius, Color(1, 0, 0, 1))  # Red circle

	# Calculate the size of the string
	var string_size = font.get_string_size(str(number))

	# Calculate the position to center the string
	var x = -string_size.x / 2 - 7
	var y = string_size.y / 2 + 1

	# Draw the number
	draw_string(
		font, Vector2(x, y), str(number), HORIZONTAL_ALIGNMENT_CENTER, -1, 40, Color(1, 1, 1, 1)
	)
