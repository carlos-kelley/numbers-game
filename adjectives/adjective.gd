class_name Adjective
extends Node2D

var description: String = ""
var effect: Effect = NoneEffect.new()
var scope: Scope = NoneScope.new()
var start_position: Vector2 = Vector2.ZERO



func _ready() -> void:
	print("Adjective ready", name)

	var label: Label = Label.new()
	label.add_theme_font_size_override("font_size", 32)

	label.text = name

	add_child(label)

#func apply_effect(card: Node2D, game: Node2D) -> void:
#return  # Implement the effect of the adjective
