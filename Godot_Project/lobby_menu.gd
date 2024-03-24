extends Control
# Implemented by Cynthia Espinoza

# Called when the node enters the scene tree for the first time.
func _ready():
	$HBoxContainer/PublicButton.grab_focus()

func _on_back_button_pressed():
	get_tree().change_scene_to_file("res://start_menu.tscn")


func _on_public_button_pressed():
	get_tree().change_scene_to_file("res://character_selection.tscn")



func _on_create_button_pressed():
	get_tree().change_scene_to_file("res://character_selection.tscn")


# Networking code beyond this point
# Implemented by Christopher Jacobs

var port = 4000
var maxplayers = 4

var nickname = ""
var player_list = {}
