extends Node

signal start_the_timer()

signal timer_is_done()


# Client side variable to store an int representing how many coins the player has.
# This will be eventually sent to the server, who will determine the victor.
var client_coins = 0

var client_kills = 0

# The next two variables should only get changed on the server side.
# id : coins dictionary. 
var player_coins = {}
# id: player wins dictionary
var playerWins = {}



# Only called once per game. Called when the host starts the game from the character
# selection menu.
func initialize():
	if MS.is_server():
		# Iterate over MS.players to initialize playerWins and player_coins.
		for player in MS.players:
			playerWins[player] = 0
			player_coins[player] = 0
		# Make sure to remove players who leave the game from playerWins and player_coins,
		# using the player disconnetced signal.
		multiplayer.peer_disconnected.connect(_on_player_disconnected)

# Called by the server when they finish loading the map
func run_match():
	# TODO:  3 second countdown, starting when all players are ready. Synced to the clients.


	# Start the timer in the current scene. Reminder to sync the timer to the clients
	GameHandler.emit_signal("start_the_timer")

	# Await the timer_finished signal emitted by the Match_Helper timer scene
	await timer_is_done
	print("Time is up. Round over.")

	# Now the timer has finished, call decide_match_victor()
	decide_match_victor()


	pass		

# Should only be called by the server. 
# This function essentially tells all clients to send 
# their coins value to the server.
func decide_match_victor():
	# Iterate over player_coins and call query_coins on each id,
	# while storing the id of the player with the most coins.

	# update playerWins

	# Check if we should call winner() or change map.
	# if nobody has won yet,
		# set everyone's client_coins to 0.
		# set all values in player_coins to 0.
		# Change map
	# else if someone has won,
		# call winner()
	pass

func winner():
	# Change everyone to the winner/gameover screen.
	# Disconnect them.
	pass

func _on_player_disconnected(id):
	# Remove the player from playerWins and player_coins
	playerWins.erase(id)
	player_coins.erase(id)
	pass

func update_client_coins(coins):
	client_coins = coins
	pass

# Only the server gets to call this. Causes someone to call
# the update_coins RPC function.
@rpc("authority", "call_remote", "reliable")
func query_coins():
	update_coins.rpc(client_coins)
	pass

# Called on the server side, by a client (or the server).
# Updates the value of player_coins with key id for the client
# that this function was called on.
@rpc("any_peer", "call_local" ,"reliable")
func update_coins(coins):
	var id = get_tree().get_rpc_sender_id()
	# Update the value of player_coins with key id
	player_coins[id] = coins
	pass


