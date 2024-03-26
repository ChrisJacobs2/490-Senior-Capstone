extends Node

@export var player_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	var players = MS.players
	for player in players:
		_add_player(player)
	pass # Replace with function body.

func _add_player(id):
	var player = player_scene.instantiate()
	player.name = str(id)
	call_deferred("add_child", player)
	pass
