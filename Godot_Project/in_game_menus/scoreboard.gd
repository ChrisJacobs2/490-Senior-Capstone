extends Control
#add coin pic
#add winner label

@onready var coin_labels = [$HBoxContainer/PanelContainer/CoinLabel, $HBoxContainer/PanelContainer2/CoinLabel,
							$HBoxContainer/PanelContainer3/CoinLabel, $HBoxContainer/PanelContainer4/CoinLabel]
@onready var kill_labels = [$HBoxContainer/PanelContainer/KillsLabel, $HBoxContainer/PanelContainer2/KillsLabel, 
							$HBoxContainer/PanelContainer3/KillsLabel, $HBoxContainer/PanelContainer4/KillsLabel]
@onready var sprite_panels = [$HBoxContainer/PanelContainer/Sprite2D, $HBoxContainer/PanelContainer2/Sprite2D,
							$HBoxContainer/PanelContainer3/Sprite2D, $HBoxContainer/PanelContainer4/Sprite2D]
@onready var panel_cards = [$HBoxContainer/PanelContainer, $HBoxContainer/PanelContainer2, 
						$HBoxContainer/PanelContainer3, $HBoxContainer/PanelContainer4]

@onready var game_handler = $"/root/GameHandler"
@onready var ms = $"/root/MS"

@onready var sprite = $"/root/MS"

#begin testing purposes
var num_players
var player_coins
var player_kills
var winner
#end of testing purposes

enum Character { PENGUIN, CLOWN, SKATER, WARRIOR }
var current_character

var clown = preload("res://assets/characters/ClownFaceIdle.png")
var penguin = preload("res://assets/characters/PenguinIdle.png")
var warrior = preload("res://assets/characters/WarriorGirlIdle.png")
var skater = preload("res://assets/characters/SkaterIdle.png")

#var coin_total = game_handler.client_coins

# Called when the node enters the scene tree for the first time.
func _ready():
	test_data()
	hide_panel_cards()
	set_panel_cards()
	set_coin_total()
	set_kill_total()
	set_character()
	$AnimationPlayer.play("fade_in")
	#fade in time + time showing scene
	await get_tree().create_timer(14).timeout
	$AnimationPlayer.play("fade_out")
	#fade out time
	await get_tree().create_timer(3).timeout
	# get_tree().change_scene_to_file("res://levels_intros/start_level.tscn")
	MS.change_scene("res://levels_intros/start_level.tscn")

#testing purposes
func test_data():
	num_players = 4
	player_coins = [10, 15, 39, 5] 
	player_kills = [4, 1, 3, 5]
	current_character = [Character.CLOWN, Character.SKATER, Character.WARRIOR, Character.PENGUIN]
	winner = 2


func _on_return_button_pressed():
	get_tree().change_scene_to_file("res://menus/lobby_menu.tscn")


#hide initial panels
func hide_panel_cards():
	for i in range (0, 4):
		panel_cards[i].hide()


#set panels = num of players
func set_panel_cards():
	for i in range (0, num_players):
		panel_cards[i].show()


#get total coins for each player
func set_coin_total():
	#loop thru each player to get their total coins for round
	#for i in range (0, ms.num_players):
		#coin_labels[i].text = " Coins: " + str(game_handler.player_coins)
	
	#this is for testing purposes
	for i in range (0, num_players):
		coin_labels[i].text = " Coins: " + str(player_coins[i])


#get total kills for each player
func set_kill_total():
	#loop thru each player to get total kills
	#for i in range (0, ms.num_players):
		#kill_labels[i].text = " Kills: " + str(game_handler.client_kills)
	
	#this is for testing purposes
	for i in range (0, num_players):
		kill_labels[i].text = " Kills: " + str(player_kills[i])


#get sprite each player is using
func set_character():
	#for i in range (0, ms.num_players):
		#if(ms.clientside_character[i] == Character.X
			#sprite_panels[i].texture = X
		
	for i in range (0, num_players):
		if(current_character[i] == Character.CLOWN):
			sprite_panels[i].texture = clown
		if(current_character[i] == Character.SKATER):
			sprite_panels[i].texture = skater
		if(current_character[i] == Character.PENGUIN):
			sprite_panels[i].texture = penguin
		if(current_character[i] == Character.WARRIOR):
			sprite_panels[i].texture = warrior
			sprite_panels[i].scale *= 2
	

#get winner from other script, hide non-winner panels, make label that appears for winner
func set_winner():
	hide_panel_cards()
	for i in range(0, num_players):
		if(winner == i):
			panel_cards[i].show
