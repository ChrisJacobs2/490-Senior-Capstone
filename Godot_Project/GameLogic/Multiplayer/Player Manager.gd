extends Node


@export var player_scene: PackedScene

@export var clown_scene: PackedScene
@export var penguin_scene: PackedScene
@export var skater_scene: PackedScene
@export var warrior_scene: PackedScene

enum Character { PENGUIN, CLOWN, SKATER, WARRIOR }

var initial_spawners

var spawner_index = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	# vars
	initial_spawners = get_tree().get_nodes_in_group("initial_player_spawn")


	var players = MS.players
	for player in players:
		_add_player(player)
		
	# If there are no players, make a peer with id 1, and add it to the scene
	# This is for dev purposes
	if len(players) == 0:
		if not MS.serverside_characters.has(1):
			MS.serverside_characters[1] = Character.CLOWN
		_add_player(1)

	# Listen to respawn_me signal
	GameHandler.respawn_me.connect(_respawn_player)


# Called from signal emitted by player. Reminder that respawning works client side.
# Respawns the player at a random spawner
# TODO: Add more spawners later, and sensible respawn locations.
func _respawn_player(player):
	# Get the number of spawners in initial_spawners
	var spawner_count = len(initial_spawners)
	# Get a random number from 0 to spawner_count - 1
	var random_index = randi() % spawner_count

	# Set the player's position to the random spawner's position
	player.position = initial_spawners[random_index].position


func _add_player(id):
	var char_name = MS.serverside_characters[id]
	# This is like a switch statement
	match char_name:
		Character.PENGUIN:
			player_scene = penguin_scene
		Character.CLOWN:
			player_scene = clown_scene
		Character.SKATER:
			player_scene = skater_scene
		Character.WARRIOR:
			player_scene = warrior_scene
		_:
			player_scene = clown_scene
			
	var player = player_scene.instantiate()
	player.name = str(id)
	call_deferred("add_child", player)
	place_player(player)

# Should only get called once per player
func place_player(player):
	player.position = initial_spawners[spawner_index].position
	spawner_index += 1
