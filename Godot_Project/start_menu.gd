extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass #$VBoxContainer/StartButton.grab_focus()


func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://lobby_menu.tscn")


func _on_options_button_pressed():
	get_tree().change_scene_to_file("res://options_menu.tscn")


func _on_quit_button_pressed():
	get_tree().quit()


func _on_credits_button_pressed():
	get_tree().change_scene_to_file("res://credits_menu.tscn")
