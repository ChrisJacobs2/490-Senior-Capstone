extends Node

@export var player_scene: PackedScene

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
	if len(players) == 0:
		_add_player(1)

	
	

func _add_player(id):
	var player = player_scene.instantiate()
	player.name = str(id)
	call_deferred("add_child", player)
	place_player(player)
	pass

func place_player(player):
	player.position = initial_spawners[spawner_index].position
	spawner_index += 1

	pass
