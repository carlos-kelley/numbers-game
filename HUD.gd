extends CanvasLayer


func _ready():
	# Connects to game_over signal from Game node
	var game_node: Node = get_node("/root/Game")
	game_node.connect("game_over", self._on_game_over)


func show_message(text: String) -> void:
	$Message.text = text
	$Message.show()


# func update_score(score: int):
# 	$P1ScoreLabel.text = str(score)


func _on_game_over() -> void:
	show_message("Game Over")
	await get_tree().create_timer(2.0).timeout
	var error: Error = get_tree().reload_current_scene()
	if error != OK:
		print("Failed to reload scene, error code: ", error)
