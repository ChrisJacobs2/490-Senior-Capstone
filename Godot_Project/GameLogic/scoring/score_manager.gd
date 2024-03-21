extends Node

var player_scores = []

var players = []

var num_players = 0

var player_id_dictionary = {}


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called right before the game starts, but after the game has been initialized
# Should be called after all players have been added to the game
func initialize_scores():
	# Iterate over every player that is currently in the game and add them to the players array
	# For every node in the group 'player'
	player_scores = []
	players = []
	num_players = 0
	var player_references = get_tree().get_nodes_in_group("player")
	for player in player_references:
		# Add the player to the players array
		players.append(player)
		# Add a score of 0 to the player_scores array
		player_scores.append(0)
		# Increment the number of players by 1
		num_players += 1

# Creats a dictionary where the key is the player's multiplayer ID and the
# value is the index of the player in the players array
func construct_dictionary():
	# Index that is incremented each time a player is added to the dictionary
	var player_index = 0
	for player in players:
		# Get the multiplayer ID for the player
		var player_id = player.get_multiplayer().get_network_unique_id()
		# Add the player ID to the dictionary with the index
		player_id_dictionary[player_id] = player_index
		# Increment the player index
		player_index += 1
		

	pass

func update_score(player_index, score):
	# Update the score of the player at the given index
	if player_scores[player_index] == null:
		print("WARNING: Score at index", player_index, "is null. Is this expected?")
	player_scores[player_index] = score

func remove_player(player_index):
	if player_scores[player_index] == null:
		print("WARNING: Score at index", player_index, "is already null!")
	else:
		# set the score to null
		player_scores[player_index] = null
	
	# decrement num_players by 1, to a minimum of 1
	num_players = max(1, num_players - 1)

func increment_score(player_index, increment):
	# Increment the score of the player at the given index
	player_scores[player_index] += increment