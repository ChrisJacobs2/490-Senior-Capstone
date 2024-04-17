extends Node2D

@export var bounce_force = 1500
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func _on_area_2d_body_entered(body):
	# If the body is a player, call bounce
	print("Body entered")
	if body.is_in_group("player"):
		print("Body is player")
		bounce(body)

# Assumes the body is a player, and has a variable called "velocity"
func bounce(player):
	print("Bouncing: ", player)
	var direction = Vector2(0, -1).rotated(rotation)
	# player.velocity.y = -bounce_force
	player.velocity = direction * bounce_force
	pass
