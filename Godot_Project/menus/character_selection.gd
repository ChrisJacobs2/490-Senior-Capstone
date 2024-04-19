extends Control

var current_selected_character_name
var penguin_king_label
var clown_face_label
var skater_boy_label
var warrior_girl_label
var start_button

enum Character { PENGUIN, CLOWN, SKATER, WARRIOR }
var current_character = Character.CLOWN


# Called when the node enters the scene tree for the first time.
func _ready():
	penguin_king_label = $PenguinKing/PenguinKingLabel
	clown_face_label = $ClownFace/ClownFaceLabel
	skater_boy_label = $SkaterBoy/SkaterBoyLabel
	warrior_girl_label = $WarriorGirl/WarriorGirlLabel
	start_button = $StartButton
	
	# default case if nobody picks character
	_on_clown_face_button_pressed()
	
	if not MS.is_server():
		start_button.hide()


func _on_back_button_pressed():
	MS.leave_game()
	get_tree().change_scene_to_file("res://menus/lobby_menu.tscn")


func _on_penguin_king_button_pressed():
	#Global.character = "PenguinKing"	
	resetLabel()
	current_character = Character.PENGUIN
	penguin_king_label.visible = true
	broadcast_character()


func _on_clown_face_button_pressed():
	#Global.character = "ClownFace"
	resetLabel()
	current_character = Character.CLOWN
	clown_face_label.visible = true
	broadcast_character()
	
	
func _on_skater_boy_button_pressed():
	#Global.character = "SkaterBoy"
	resetLabel()
	current_character = Character.SKATER
	skater_boy_label.visible = true
	broadcast_character()
	
func _on_warrior_girl_button_pressed():
	#Global.character = "WarriorGirl"
	resetLabel()
	current_character = Character.WARRIOR
	warrior_girl_label.visible = true
	broadcast_character()
	
	# This button is labled Force Start. Only the host should be able to push this.
	# I plan on adding more ways for the game to start, such as 4 people being ready.
func _on_start_button_pressed():
	#if Global.character == null:
		#pass
	#else:
	if MS.is_server():
		GameHandler.initialize()
		startGame.rpc()
	
	
func resetLabel():
	penguin_king_label.hide()
	clown_face_label.hide()
	skater_boy_label.hide()
	warrior_girl_label.hide()
	pass

func broadcast_character():
	submit_character.rpc(current_character)

# Called remotely by the server. Runs on everyone's machine.
@rpc("authority", "call_local", "reliable")
func startGame():
	# Give everyone the character that the client selected
	# submit_character.rpc(current_character)
	MS.change_scene("res://levels_intros/instruct_loading.tscn")

# Called remotely by clients and locally by server. Recipient is server.
# Adds the character to the server's MS.serverside_characters dictionary, then starts the game.
@rpc("any_peer", "call_local", "reliable")
func submit_character(character):
	# whoever sent the RPC call
	var id = multiplayer.get_remote_sender_id()
	# Adds an entry to the serverside dictionary with key (sender id) and
	# value (character value passed through the RPC)
	MS.serverside_characters[id] = character
	pass
