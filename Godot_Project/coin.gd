extends Area2D


func _on_body_entered(body):
	if body.name == "clown" || body.name == "penguin" || body.name == "skater" || body.name == "warrior":
		body.coins += 1
		queue_free()
