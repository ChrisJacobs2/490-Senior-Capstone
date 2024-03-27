extends Node


# Client side variable to store an int representing how many coins the player has.
# This will be eventually sent to the srever, who will determine the victor.
var client_coins = 0

# The next two variables should only get changed on the server side.
# id : coins dictionary. 
var player_coins = {}
# id: player wins dictionary
var playerWins = {}


func _on_player_disconnected(id):
	# Remove the player from playerWins and player_coins
	playerWins.erase(id)
	player_coins.erase(id)
	pass

# Only called once per game.
func initialize():
	if MS.is_server():
		# Iterate over MS.players to initialize playerWins and player_coins.
		for player in MS.players:
			playerWins[player] = 0
			player_coins[player] = 0
		# Make sure to remove players who leave the game from playerWins and player_coins,
		# using the player disconnetced signal.
		multiplayer.peer_disconnected.connect(_on_player_disconnected)
		

# Should only be called by the server. 
# This function essentially tells all clients to send 
# their coins value to the server.
func decideVictor():
	# Iterate over player_coins and call query_coins on each id,
	# while storing the id of the player with the most coins.

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

func run_game():
	# Call run_round until there's a player with two wins, or the only player left is the host.
	pass

func run_round():
	pass



