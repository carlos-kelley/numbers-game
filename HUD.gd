extends CanvasLayer


func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()

func _on_message_timer_timeout():
	$Message.hide()

func update_score(score):
	$P1ScoreLabel.text = str(score)

func show_game_over():
	show_message("Game Over")
	# Wait until the MessageTimer has counted down.
	await $MessageTimer.timeout
	# Restart the game.
	get_tree().reload_current_scene()
