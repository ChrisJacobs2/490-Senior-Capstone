extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("Fade_In")
	#fade in time + time showing scene
	await get_tree().create_timer(14).timeout
	$AnimationPlayer.play("Fade_Out")
	#fade out time
	await get_tree().create_timer(3).timeout
	get_tree().change_scene_to_file("res://start_level.tscn")

