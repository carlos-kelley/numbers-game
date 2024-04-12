class_name Adjective
extends Node2D

var description: String = ""
var effect: Effect = NoneEffect.new()
var scope: Scope = NoneScope.new()


func _ready() -> void:
	print("Adjective ready", name)
	var label: Label = Label.new()
	label.text = name
	add_child(label)

#func apply_effect(card: Node2D, game: Node2D) -> void:
#return  # Implement the effect of the adjective
