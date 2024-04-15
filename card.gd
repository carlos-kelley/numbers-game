class_name Card
extends TextureButton

signal card_dropped
var draggable: Draggable

var texture_paths: Dictionary = {}

# Value has setter so we can update texture when it changes
var _player: Player = NonePlayer.new()
var player: Player:
	get:
		return _player
	set(new_player):
		_player.remove_child(self)
		_player = new_player
		_player.add_child(self)
var _value: int = 0
var value: int:
	get:
		return _value
	set(new_value):
		_value = new_value
		# This texture is from Node2D
		$Sprite2D.texture = texture_paths[value]
var is_dragging: bool = false
var drag_offset: Vector2 = Vector2.ZERO
var start_position: Vector2 = Vector2.ZERO
# var font: Font = ThemeDB.fallback_font
var adjective: Adjective = NoneAdjective.new()
var is_draggable: bool = true


func _init() -> void:
	print("Card init.")
	for i: int in range(10):
		texture_paths[i] = load("res://images/" + str(i) + ".png")


@onready var game: GameLogic = get_node("/root/Game")


func _ready() -> void:
	print("Card ready.")
	#draggable is a new getting passed in the sprite2d child of the card
	draggable = Draggable.new(self)
	print("Card draaggable is ", self)
	draggable.owner = self
