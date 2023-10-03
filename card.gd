extends Node2D

var number: int = 0  # The number to display
var radius: int = 30  # Radius of the circle
var font = ThemeDB.fallback_font


func _draw():
	# Draw the circle
	draw_circle(Vector2(0, 0), radius, Color(1, 0, 0, 1))  # Red circle

	# Calculate the size of the string
	var string_size = font.get_string_size(str(number))
	print(string_size)  # log the size

	# Calculate the position to center the string
	var x = -string_size.x / 2 - 7
	var y = string_size.y / 2 + 1

	# Draw the number
	draw_string(
		font, Vector2(x, y), str(number), HORIZONTAL_ALIGNMENT_CENTER, -1, 40, Color(1, 1, 1, 1)
	)
