extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$HBoxContainer/PublicButton.grab_focus()




func _on_back_button_pressed():
	get_tree().change_scene_to_file("res://start_menu.tscn")


func _on_public_button_pressed():
	get_tree().change_scene_to_file("res://character_selection.tscn")


func _on_private_button_pressed():
	get_tree().change_scene_to_file("res://character_selection.tscn")


func _on_create_button_pressed():
	get_tree().change_scene_to_file("res://character_selection.tscn")
