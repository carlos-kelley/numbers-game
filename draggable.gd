class_name Draggable
extends Control

signal card_dropped(draggable)

var node: Control
var is_dragging: bool = false
var drag_offset: Vector2 = Vector2.ZERO
var start_position: Vector2 = Vector2.ZERO
var is_draggable: bool = true
var mouse_is_inside: bool = false


func _init(_node) -> void:
	print("Draggable init", _node)
	node = _node
	node.connect("mouse_entered", self._on_mouse_entered)
	node.connect("mouse_exited", self._on_mouse_exited)


func _on_mouse_entered() -> void:
	print("Mouse entered")
	mouse_is_inside = true


func _on_mouse_exited() -> void:
	print("Mouse exited")
	mouse_is_inside = false


func _input(event: InputEvent) -> void:
	var mouse_pos: Vector2 = get_global_mouse_position()
	if is_draggable == false:
		print("Not draggable")
		return

	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed and mouse_is_inside:
			print("Mouse pressed")
			is_dragging = true
			print("Is dragging", is_dragging)
			drag_offset = mouse_pos - node.global_position
		elif not event.pressed:
			print("Mouse released")
			is_dragging = false
			print("Is dragging", is_dragging)
			emit_signal("card_dropped", self)

	elif event is InputEventMouseMotion and is_dragging:
		print("Mouse moved")
		node.global_position = mouse_pos - drag_offset
