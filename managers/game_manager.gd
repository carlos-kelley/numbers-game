extends Node

var target_node = null


func _ready():
	target_node = get_node("/root/Game")
	print("target_node: ", target_node)


func get_target_node():
	return target_node
