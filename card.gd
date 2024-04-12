class_name Card
extends Sprite2D
# Preload textures in a dictionary
var texture_paths: Dictionary = {}

var value: int:
	set(new_value):
		_value = new_value
		texture = texture_paths[_value]
var is_dragging: bool = false
var drag_offset: Vector2 = Vector2.ZERO
var start_position: Vector2 = Vector2.ZERO
# var font: Font = ThemeDB.fallback_font
var adjective: Adjective = NoneAdjective.new()
var player: String = ""
var is_draggable: bool = true
var _value: int = 0


func _init() -> void:
	print("Card init.")
	for i: int in range(10):
		texture_paths[i] = load("res://images/" + str(i) + ".png")
		print(texture_paths[i])


@onready var game: GameLogic = get_node("/root/Game")


func _ready() -> void:
	print("Card ready.")
