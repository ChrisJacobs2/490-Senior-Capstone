extends Control


#add winner label

@onready var coin_labels = [$HBoxContainer/PanelContainer/CoinLabel, $HBoxContainer/PanelContainer2/CoinLabel,
							$HBoxContainer/PanelContainer3/CoinLabel, $HBoxContainer/PanelContainer4/CoinLabel]
@onready var sprite_panels = [$HBoxContainer/PanelContainer/Sprite2D, $HBoxContainer/PanelContainer2/Sprite2D,
							$HBoxContainer/PanelContainer3/Sprite2D, $HBoxContainer/PanelContainer4/Sprite2D]
@onready var panel_cards = [$HBoxContainer/PanelContainer, $HBoxContainer/PanelContainer2, 
						$HBoxContainer/PanelContainer3, $HBoxContainer/PanelContainer4]
@onready var name_labels = [$HBoxContainer/PanelContainer/NameLabel, $HBoxContainer/PanelContainer2/NameLabel,
							$HBoxContainer/PanelContainer3/NameLabel, $HBoxContainer/PanelContainer4/NameLabel]
@onready var win_labels = [$HBoxContainer/PanelContainer/WinLabel, $HBoxContainer/PanelContainer2/WinLabel, 
							$HBoxContainer/PanelContainer3/WinLabel, $HBoxContainer/PanelContainer4/WinLabel]


enum Character { PENGUIN, CLOWN, SKATER, WARRIOR }
var current_character

var clown = preload("res://assets/characters/ClownFaceIdle.png")
var penguin = preload("res://assets/characters/PenguinIdle.png")
var warrior = preload("res://assets/characters/WarriorGirlIdle.png")
var skater = preload("res://assets/characters/SkaterIdle.png")



# Called when the node enters the scene tree for the first time.
func _ready():
	hide_panel_cards()
	set_panel_cards()
	set_coin_total()
	set_character()
	set_nickname()
	#set_winner()
	
	#$AnimationPlayer.play("fade_in")
	#fade in time + time showing scene
	await get_tree().create_timer(4).timeout
	#$AnimationPlayer.play("fade_out")
	#fade out time
	#await get_tree().create_timer(3).timeout
	MS.change_scene("res://levels_intros/start_level_2.tscn")


func _on_return_button_pressed():
	get_tree().change_scene_to_file("res://menus/lobby_menu.tscn")


#hide initial panels
func hide_panel_cards():
	for i in range (0, 4):
		panel_cards[i].hide()


#set panels = num of players
func set_panel_cards():
	var panel_counter = 0
	for i in MS.players:
		panel_cards[panel_counter].show()
		panel_counter+=1	


#get total coins for each player
func set_coin_total():
	#loop thru each player to get their total coins for round
	print("entered coin fn")
	var coin_panels = 0
	var players = get_tree().get_nodes_in_group("player")

	for player in players:
		print("reached loop")

		coin_labels[coin_panels].text = " Coins: " + str(player.coins)
		coin_panels+=1


#get sprite each player is using
func set_character():
	var sprite_counter = 0
	for i in MS.players.keys():
		if(MS.serverside_characters[i] == Character.CLOWN):
			sprite_panels[sprite_counter].texture = clown
		if(MS.serverside_characters[i] == Character.SKATER):
			sprite_panels[sprite_counter].texture = skater
		if(MS.serverside_characters[i] == Character.PENGUIN):
			sprite_panels[sprite_counter].texture = penguin
		if(MS.serverside_characters[i] == Character.WARRIOR):
			sprite_panels[sprite_counter].texture = warrior
			sprite_panels[sprite_counter].scale *= 2
		sprite_counter +=1
	
	
func set_nickname():
	var name_counter = 0
	for i in MS.players.keys():
		name_labels[name_counter].text = " " + str(MS.players[i])
		name_counter += 1
	

#get winner, make label that appears for winner
func set_winner():
	for i in MS.num_players:
		if GameHandler.playerWins[i] > 0:
			win_labels[i].show()
			
	var players = get_tree().get_nodes_in_group("player")
	var max_coins = -1
	var max_id = null

