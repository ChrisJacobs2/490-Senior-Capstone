extends Node2D

var current_selected_character_name
var penguin_king_label
var clown_face_label
var skater_boy_label
var warrior_girl_label


# Called when the node enters the scene tree for the first time.
func _ready():
	penguin_king_label = $PenguinKing/PenguinKingLabel
	clown_face_label = $ClownFace/ClownFaceLabel
	skater_boy_label = $SkaterBoy/SkaterBoyLabel
	warrior_girl_label = $WarriorGirl/WarriorGirlLabel


func _on_back_button_pressed():
	get_tree().change_scene_to_file("res://lobby_menu.tscn")


func _on_penguin_king_button_pressed():
	#Global.character = "PenguinKing"	
	penguin_king_label.visible = true


func _on_clown_face_button_pressed():
	#Global.character = "ClownFace"
	clown_face_label.visible = true
	
	
func _on_skater_boy_button_pressed():
	#Global.character = "SkaterBoy"
	skater_boy_label.visible = true
	
	
func _on_warrior_girl_button_pressed():
	#Global.character = "WarriorGirl"
	warrior_girl_label.visible = true
	
	
func _on_start_button_pressed():
	#if Global.character == null:
		#pass
	#else:
	get_tree().change_scene_to_file("res://instructions_loading.tscn")
