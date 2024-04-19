extends RigidBody2D
class_name Coin

@export_category("Coin")

var rng = RandomNumberGenerator.new()

func _ready():
	var my_random_number = rng.randf_range(-200.0, 200.0)
	linear_velocity.x = my_random_number

func _on_bounce_hitbox_body_entered(body):
	if body.name == "Bullet":
		pass
	else:
		linear_velocity.y = -linear_velocity.y/1.2
