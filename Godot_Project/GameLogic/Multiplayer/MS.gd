extends Node

signal update_player_list()




# Default address and port
@export var Address = "localhost"
@export var port = 4000

var max_players = 4
var num_players = 0
var players_loaded = 0
var peer
var in_lobby


# This is the compression type used for the connection.
# Both clients and the server must use the same compression type.
var compression_type = ENetConnection.COMPRESS_RANGE_CODER	# check docs for other options

# This will contain player info for every player,
# with the keys being each player's unique IDs.
var players = {}

# This is the local player name. This should be modified locally
# before the connection is made. It will be passed to every other peer.
# For example, the value of "name" can be set to something the player
# entered in a UI scene.
var player_name = ""

# Enum class for character selection purposes
enum Character { PENGUIN, CLOWN, SKATER, WARRIOR }
# This is the local character. Should be modified locally before loading a map.
# It should be an enum value from the Character class.
var clientside_character

# Called when the node enters the scene tree for the first time.
func _ready():
	# networking signals
	multiplayer.peer_connected.connect(_on_player_connected)
	multiplayer.peer_disconnected.connect(_on_player_disconnected)
	multiplayer.connected_to_server.connect(_on_connected_ok)
	multiplayer.connection_failed.connect(_on_connected_fail)
	multiplayer.server_disconnected.connect(_on_server_disconnected)

	# gameplay signals
	


# This gets called on the server and clients every time someone else connects
# For the person joining, this function gets called for every player in the server (host included)
# For the host, and players who are already in the game, this function gets called for every player that joins
# id is the unique ID of the player that triggered this function, so you will never see your own ID here
func _on_player_connected(id):
	print("Player connected: ", id)
	# Add ourselves to the joiner's player list
	add_player.rpc_id(id, player_name)
	# say_hi.rpc_id(id, "hi")
	if is_server():
		# up to max_players (4) players can be counted
		num_players = min(max_players, num_players + 1)
		print("Added player: ", num_players)


# This gets called on the server and clients when someone disconnects
func _on_player_disconnected(id):
	print("Player disconnected: ", id)
	# remove the player from the list
	players.erase(id)
	emit_signal("update_player_list")
	if is_server():
		# down to 1 player can be counted
		print("decrementing")
		num_players = max(1, num_players - 1)


# This is called on the client when it connects to the server
func _on_connected_ok():
	print("Connected to server")
	# Add ourselves to our list of players in 10ms
	# The delay is so that we are at the bottom of the list
	await get_tree().create_timer(0.1).timeout
	players[multiplayer.get_unique_id()] = player_name
	# Add ourselves to everyone's player list
	add_player.rpc(player_name)
	# We could get around this by having the server use an RPC to tell
	# The client to add themselves to the list but I think its less graceful


# This is called on the client when it fails to connect to the server
func _on_connected_fail():
	print("Connection failed")
# This is called on the client when the server disconnects
func _on_server_disconnected():
	if in_lobby == false:
		get_tree().change_scene_to_file("res://menus/lobby_menu.tscn")
	leave_game()
	print("Server disconnected")



# RPC test function
@rpc("any_peer", "call_local", "reliable")
func say_hi(message):
	print("Received message: ", message, " from ", multiplayer.get_remote_sender_id())
	pass

# This remote function adds our name to someone elses player list.
@rpc("any_peer", "call_local", "reliable")
func add_player(our_name):
	var our_id = multiplayer.get_remote_sender_id()
	players[our_id] = our_name
	emit_signal("update_player_list")


@rpc("authority", "call_local", "reliable")
func load_game(game_scene_path):
	in_lobby = false
	get_tree().change_scene_to_file(game_scene_path)



func is_server():
	return multiplayer.is_server()

func leave_game():
	players = {}
	multiplayer.multiplayer_peer = null
	peer = null


func host_game():
	peer = ENetMultiplayerPeer.new()
	# The host is not counted in te max_clients argument, so we decrease it by 1
	var error = peer.create_server(port, max_players - 1)
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
	return OK

func test():
	print("Test")

# Can be called by anyone, but the load_game() rpc call requires you to be the server.
# Tells everyone to change the scene.
func change_scene(scene_path):
	if is_server():
		load_game.rpc(scene_path)

