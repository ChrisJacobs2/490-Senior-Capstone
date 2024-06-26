extends Node

signal start_the_timer()

signal timer_is_done()

# Sent by character, received by Player Manager node (in arena).
signal respawn_me()

#boolean which becomes true when a player wins the game (2 rounds)
var someone_won = false

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
		# We iterate over this dictionary in case some players haven't loaded the map yet.
		# Since the player ids are intergers, beware of type mismatches.
		for player in MS.players:
			playerWins[player] = 0
			player_coins[player] = 0
		rpc("initialize_playerWins")

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
	# Find out who has the most coins
		# First, get a list of every node in group 'player' and call it players
	#var players = get_tree().get_nodes_in_group("player")
	
		# Then, iterate over the player list, saving the player with the most coins
	#var max_coins = -1
	#var max_id = null
	#for player in players:
		#player_coins[player] = player.coins
		#if player.coins > max_coins:
			#max_coins = player.coins
			#max_id = player.name		# This is a stringname, not an int. Therefore, it must be converted.
			
		#pass
	#max_id = int(str(max_id))
	#print("Host: The player wins dictionary: ", playerWins)
	#print("Host: The winning player id: ", max_id)
	# update playerWins accordingly
	#playerWins[max_id] += 1

	# For the demo, we just set the host to win
	# print("host wins")
	# var id = multiplayer.get_unique_id()	# the host id
	# playerWins[id] += 1	# If this function runs in singleplayer and it will cause a crash because the players list is empty.
	
	#increase number of rounds completed
	MS.round_counter += 1

	#rpc so each player gets the updated playerWins dictionary
	rpc("playerWins_info")
	
	#rpc to display scoreboard for all players
	rpc("show_scoreboard_to_all")
	
	#check if someone won
	for player in playerWins:
		if playerWins[player] == 2:
			someone_won = true
			winner()
			break
		
	#if nobody won, go to next round	
	if someone_won == false:
		MS.change_scene("res://levels_intros/start_level_" + str(MS.round_counter) + ".tscn")		

	
	pass
	

func display_scoreboard():
	#get player coin info
	var players = get_tree().get_nodes_in_group("player")
	for player in players:
		player_coins[player] = player.coins

	#show scoreboard
	var popup_scoreboard = preload("res://in_game_menus/scoreboard.tscn").instantiate()
	popup_scoreboard.position = get_viewport().get_visible_rect().position
	
	#make canvas layer so scoreboard is in foreground
	var sb_layer = CanvasLayer.new()
	add_child(sb_layer)
	sb_layer.add_child(popup_scoreboard)
	
	#show scoreboard
	sb_layer.show()
	await get_tree().create_timer(6).timeout
	sb_layer.hide()
	

func winner():
	print("Someone Won!!!")
	MS.game_over = true
	# Change everyone to the winner/gameover screen.
	MS.change_scene("res://menus/game_over_menu.tscn")
	# Stop hosting. This should disconnect everyone.
	await get_tree().create_timer(7).timeout
	MS.leave_game()
	pass

func _on_player_disconnected(id):
	# Remove the player from playerWins and player_coins
	playerWins.erase(id)
	player_coins.erase(id)
	pass

func update_client_coins(coins):
	client_coins = coins
	pass


# rpc to display scoreboard
@rpc("any_peer", "call_local", "reliable")
func show_scoreboard_to_all():
	display_scoreboard()

	
# rpc to initialize playerwins for every player
@rpc("any_peer", "call_local", "reliable")
func initialize_playerWins():
	for player in MS.players:
		playerWins[player] = 0
	
		
# rpc to send playerWins info to everyone
@rpc("any_peer", "call_local", "reliable")
func playerWins_info():
	#get playerWins info	
	var players = get_tree().get_nodes_in_group("player")

	var max_coins = -1
	var max_id = null
	#find which player won the round
	for player in players:
		player_coins[player] = player.coins
		if player.coins > max_coins:
			max_coins = player.coins
			max_id = player.name
	max_id = int(str(max_id))
	playerWins[max_id] += 1
	

# Only the server gets to call this. Causes someone to call
# the update_coins RPC function.
@rpc("authority", "call_remote", "reliable")
func query_coins():
	update_coins.rpc(client_coins)
	pass

# Called on the server side, by a client (or the server).
# Updates the value of player_coins with key id for the client
# that this function was called on.

# This RPC function can be called by any peer. Whoever executes the function will
# update their value of player_coins with the key being the id of the
# RPC sender. Basically, a client "bobby" can RPC this function to everyone to
# update their player_coins dictionary with "bobby"'s id as the key.
@rpc("any_peer", "call_local" ,"reliable")
func update_coins(coins):
	var id = get_tree().get_rpc_sender_id()
	# Update the value of player_coins with key id
	player_coins[id] = coins

	pass


