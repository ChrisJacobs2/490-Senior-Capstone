extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("fade_in")
	#fade in time + time showing scene
	await get_tree().create_timer(14).timeout
	$AnimationPlayer.play("fade_out")
	#fade out time
	await get_tree().create_timer(3).timeout
	get_tree().change_scene_to_file("res://levels_intros/start_level.tscn")

