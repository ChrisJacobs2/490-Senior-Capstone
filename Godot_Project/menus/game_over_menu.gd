extends Control

@onready var sprite_panel = $HBoxContainer/PanelContainer/Sprite2D
@onready var name_label = $HBoxContainer/PanelContainer/NameLabel

enum Character { PENGUIN, CLOWN, SKATER, WARRIOR }
var current_character

var clown = preload("res://assets/characters/ClownFaceIdle.png")
var penguin = preload("res://assets/characters/PenguinIdle.png")
var warrior = preload("res://assets/characters/WarriorGirlIdle.png")
var skater = preload("res://assets/characters/SkaterIdle.png")



# Called when the node enters the scene tree for the first time.
func _ready():
	is_winner()
	MS.game_over = true
	pass 


func is_winner():
	#identify winning player
	for player in GameHandler.playerWins.keys():
		if GameHandler.playerWins[player] == 2:
			var winning_player = player
			set_winner(winning_player)


func set_winner(winning_player):
	#set sprite & other info for winning player
	if(MS.serverside_characters[winning_player] == Character.CLOWN):
		sprite_panel.texture = clown
	if(MS.serverside_characters[winning_player] == Character.SKATER):
		sprite_panel.texture = skater
	if(MS.serverside_characters[winning_player] == Character.PENGUIN):
		sprite_panel.texture = penguin
	if(MS.serverside_characters[winning_player] == Character.WARRIOR):
		sprite_panel.texture = warrior
		sprite_panel.scale *= 2
	
	name_label.text = " " + str(MS.players[winning_player])
	

func _on_return_button_pressed():
	get_tree().change_scene_to_file("res://menus/lobby_menu.tscn")


func _on_quit_button_pressed():
	get_tree().quit()
