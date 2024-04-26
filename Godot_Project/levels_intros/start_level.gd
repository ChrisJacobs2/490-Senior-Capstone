extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("fade_in")
	#fade in time + time showing scene
	await get_tree().create_timer(6).timeout
	$AnimationPlayer.play("fade_out")
	#fade out time
	await get_tree().create_timer(3).timeout
	#go to arena1
	MS.change_scene("res://Maps/Arena_1/arena_1.tscn")
