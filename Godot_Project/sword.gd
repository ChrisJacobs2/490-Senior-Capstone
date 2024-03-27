extends Area2D


func _on_hitbox_body_entered(body):
	if body.name == "clown" || body.name == "penguin" || body.name == "skater" || body.name == "warrior":
		body.damage()
