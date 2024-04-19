extends Area2D


func _on_body_entered(body):
	if body.is_in_group("player"):
		if body.is_alive:
			body.coins += 1
			body.update_coins_ui()
			get_parent().queue_free()
