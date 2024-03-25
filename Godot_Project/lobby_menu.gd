extends Control

@export var Address = "127.0.0.1"
@export var port = 4000
var max_players = 4
var players_loaded = 0
var peer
var compression_type = ENetConnection.COMPRESS_RANGE_CODER	# check docs for other options
var menus_are_up = false
var lobby_player_list
var join_name_box
var host_name_box



# This will contain player info for every player,
# with the keys being each player's unique IDs.
var players = {}

# This is the local player name. This should be modified locally
# before the connection is made. It will be passed to every other peer.
# For example, the value of "name" can be set to something the player
# entered in a UI scene.
var player_name = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	$HBoxContainer/JoinButton.grab_focus()
	lobby_player_list = $lobby/VBoxContainer/PlayerList		# This is an ItemList
	join_name_box = $"Join Match/VBoxContainer/nickname"
	host_name_box = $"Host Match/VBoxContainer/nickname"
	initialize_menu()
	
	# multiplayer signals
	multiplayer.peer_connected.connect(_on_player_connected)
	multiplayer.peer_disconnected.connect(_on_player_disconnected)
	multiplayer.connected_to_server.connect(_on_connected_ok)
	multiplayer.connection_failed.connect(_on_connected_fail)
	multiplayer.server_disconnected.connect(_on_server_disconnected)
	
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
		multiplayer.multiplayer_peer = null
		peer = null
		initialize_menu()
	else:
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


# This gets called on the server and clients when someone connects
func _on_player_connected(id):
	print("Player connected: ", id)

	pass


# This gets called on the server and clients when someone disconnects
func _on_player_disconnected(id):
	print("Player disconnected: ", id)
	pass
# This is called on the client when it connects to the server
func _on_connected_ok():
	print("Connected to server")
	pass
# This is called on the client when it fails to connect to the server
func _on_connected_fail():
	print("Connection failed")
	pass
func _on_server_disconnected():
	print("Server disconnected")
	_on_back_button_pressed()


func _on_join_submit():
	# Set the player's name
	player_name = join_name_box.text
	join_game()

func on_host_submit():
	# Set the player's name
	player_name = host_name_box.text
	host_game()


func join_game():
	# Default to localhost if no IP is provided
	peer = ENetMultiplayerPeer.new()
	var error = peer.create_client(Address, port)
	if error != OK:
		print("Error creating client", error)
		return error
	# As below, optional. Must have same compression for host and client. 
	peer.get_host().compress(compression_type)
	multiplayer.set_multiplayer_peer(peer)	# set yourself as the multiplayer peer

	$"Join Match".hide()
	$lobby.show()

func host_game():
	peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(port, max_players)
	if error != OK:
		print("Error creating server", error)
		return
	# Optional, saves bandwidth at the expense of the CPU. 
	peer.get_host().compress(compression_type)

	multiplayer.set_multiplayer_peer(peer)	# set yourself as the multiplayer peer
	print("waiting for players")
	print("Host's Name: ", player_name)
	# Add the player_name to players
	players[peer.get_unique_id()] = player_name

	$"Host Match".hide()
	$lobby.show()
	update_player_list()

func update_player_list():
	lobby_player_list.clear()
	for player in players:
		lobby_player_list.add_item(players[player])
	pass

