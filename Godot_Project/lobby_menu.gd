extends Control

@export var Address = "127.0.0.1"
@export var port = 4000
var max_players = 4
var peer
var compression_type = ENetConnection.COMPRESS_RANGE_CODER	# check docs for other options
var username = ""
var menus_are_up = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$HBoxContainer/JoinButton.grab_focus()
	initialize_menu()
	
	# multiplayer stuff
	multiplayer.peer_connected.connect(player_connected)
	multiplayer.peer_disconnected.connect(player_disconnected)
	multiplayer.connected_to_server.connect(connected_to_server)
	multiplayer.connection_failed.connect(connection_failed)
	
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
func player_connected(id):
	print("Player connected: ", id)
	pass
# This gets called on the server and clients when someone disconnects
func player_disconnected(id):
	print("Player disconnected: ", id)
	pass
# This is called on the client when it connects to the server
func connected_to_server():
	print("Connected to server")
	pass
# This is called on the client when it fails to connect to the server
func connection_failed():
	print("Connection failed")
	pass


func _on_join_submit():
	peer = ENetMultiplayerPeer.new()
	peer.create_client(Address, port)
	# As above, optional. Must have same compression for host and client. 
	peer.get_host().compress(compression_type)
	multiplayer.set_multiplayer_peer(peer)	# set yourself as the multiplayer peer

	$"Join Match".hide()
	$lobby.show()


func on_host_submit():
	peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(port, max_players)
	if error != OK:
		print("Error creating server", error)
		return
	# Optional, saves bandwidth at the expense of the CPU. 
	peer.get_host().compress(compression_type)

	multiplayer.set_multiplayer_peer(peer)	# set yourself as the multiplayer peer
	print("waiting for players")
	$"Host Match".hide()
	$lobby.show()
