extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	MS.game_over = true
	pass # Replace with function body.


func _on_return_button_pressed():
	get_tree().change_scene_to_file("res://menus/lobby_menu.tscn")


func _on_quit_button_pressed():
	get_tree().quit()
