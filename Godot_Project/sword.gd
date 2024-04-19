extends Area2D


func _on_hitbox_body_entered(body):
	if body.is_in_group("player") && get_meta("Active") == true:
		body.damage()
