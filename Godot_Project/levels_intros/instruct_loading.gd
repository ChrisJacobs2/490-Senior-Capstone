extends Control

# Default 14 seconds, can be changed in the Inspector tab
@export var fade_in_timer = 14

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("fade_in")
	#fade in time + time showing scene
	await get_tree().create_timer(6).timeout
	$AnimationPlayer.play("fade_out")
	#fade out time
	await get_tree().create_timer(3).timeout

	#go to start round 1 scene
	MS.change_scene("res://levels_intros/start_level.tscn")

