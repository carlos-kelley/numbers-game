extends Node2D

var number: int = 0
var radius: int = 30
var in_hand: bool = true
var is_dragging = false
var drag_offset = Vector2()
var font = ThemeDB.fallback_font

signal card_clicked(card_node)
signal card_dropped(card_node)


func _input(event):
	if in_hand:
		if event is InputEventMouseButton:
			var mouse_pos = get_global_mouse_position()
			var distance_to_center = mouse_pos.distance_to(global_position)
			if distance_to_center <= radius:
				if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
					print("Is dragging.")
					is_dragging = true
					drag_offset = mouse_pos - global_position
				elif not event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
					print("Not dragging.")
					is_dragging = false
					emit_signal("card_dropped", self)
		elif event is InputEventMouseMotion and is_dragging:
			global_position = event.global_position - drag_offset

func _draw():
	draw_circle(Vector2(0, 0), radius, Color(1, 0, 0, 1))

	draw_string(
		font, Vector2(-12,13), str(number), HORIZONTAL_ALIGNMENT_CENTER, -1, 40, Color(1, 1, 1, 1)
	)
