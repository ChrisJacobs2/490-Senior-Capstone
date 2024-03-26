extends Control

# USES THE MS.gd AUTOLOAD SCRIPT GLOBALLY
# FOR EXAMPLE: MS.function(args)
#			   var varialbe = MS.variable


var menus_are_up = false
var lobby_player_list
var join_name_box
var host_name_box
var join_ip_box
var join_match_label
var start_game_button




# Called when the node enters the scene tree for the first time.
func _ready():
	$HBoxContainer/JoinButton.grab_focus()
	lobby_player_list = $lobby/VBoxContainer/PlayerList		# This is an ItemList
	join_name_box = $"Join Match/VBoxContainer/nickname"
	join_ip_box = $"Join Match/VBoxContainer/ipaddress"
	host_name_box = $"Host Match/VBoxContainer/nickname"
	join_match_label = $"Join Match/VBoxContainer/Label"

	# we may want to hide this for non host players
	start_game_button = $lobby/VBoxContainer/StartGame	
	
	# multiplayer signals
	multiplayer.server_disconnected.connect(_on_server_disconnected)
	MS.connect("update_player_list", _on_player_update)
	

	initialize_menu()


func _on_player_update():
	update_player_list()

	
func initialize_menu():
	$lobby.hide()
	$"Join Match".hide()
	$"Host Match".hide()
	$BackButton.show()
	$Label.show()
	$HBoxContainer.show()
	menus_are_up = false
	
func hide_menu():
	$Label.hide()
	$HBoxContainer.hide()
	pass

func _on_back_button_pressed():
	if menus_are_up:
		MS.leave_game()
		initialize_menu()
		pass
	else:
		# There shouldn't be a game to leave.
		get_tree().change_scene_to_file("res://start_menu.tscn")

func _on_host_button():
	hide_menu()
	menus_are_up = true
	$"Host Match".show()
	pass

func _on_join_button():
	hide_menu()
	menus_are_up = true
	$"Join Match".show()
	pass # Replace with function body.


# This is called on the client when the server disconnects
func _on_server_disconnected():
	print("Server disconnected")
	_on_back_button_pressed()

# The submit button in the 'join' menu
func _on_join_submit():
	# Set the player's name
	MS.player_name = join_name_box.text
	# Set the IP address if not null
	if join_ip_box.text != "":
		MS.Address = join_ip_box.text
	var error = MS.join_game()
	if error != OK:
		print("Error joining game: ", error)

	else:	# No immediate connection errors
		var peer = MS.peer
		$"Join Match".hide()
		$lobby.show()
		# Wait for a while to see if the connection is established
		await get_tree().create_timer(5.0).timeout
		# If it is established, do nothing. Otherwise, kick the player back to the join menu.
		if peer.get_connection_status() == 1:
			print("Error: Could not connect to server")
			$"Join Match".show()
			$lobby.hide()
			MS.leave_game()
			join_match_label.text = "Could not connect to server. :("

		
# The submit button in the 'host' menu
func on_host_submit():
	# Set the player's name
	MS.player_name = host_name_box.text
	MS.host_game()
	print("hosting")
	$"Host Match".hide()
	$lobby.show()
	update_player_list()

func _on_start_game_pressed():
	MS.start_game()
	pass # Replace with function body.


func leave_game():
	MS.leave_game()
	initialize_menu()

func update_player_list():
	lobby_player_list.clear()
	var players = MS.players
	for player in players:
		lobby_player_list.add_item(players[player])
	pass



# # This function gets called remotely by every player who joins, on every player who is already in the game (including the server).
# # Because Godot devs are soooooo cool and smart, this function also gets called on the player who just joined, by every other player (including server).
# # So it's convenient for synching the player list.
# @rpc("any_peer", "call_local", "reliable")
# func add_player(their_name):
# 	var their_id = multiplayer.get_remote_sender_id()
# 	# Add the player to the list for EVERYONE, as well as the server
# 	players[their_id] = their_name
# 	update_player_list()
# 	pass



@rpc("any_peer", "call_local", "reliable")
func load_game(game_scene_path):
	get_tree().change_scene_to_file(game_scene_path)
