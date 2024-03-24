extends Node2D


var peer = ENetMultiplayerPeer.new()
@export var player_scene: PackedScene


func _on_host_pressed():
	peer.create_server(135)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(_add_player)
	_add_player()
	# Remove the button that this function is connected to
	$Host.queue_free()
	$Join.queue_free()

func _add_player(id = 1):
	var player = player_scene.instantiate()
	player.name = str(id)
	call_deferred("add_child", player)
	pass


func _on_join_pressed():
	peer.create_client("192.168.1.113", 135)
	multiplayer.multiplayer_peer = peer
	# Remove the button that this function is connected to
	$Host.queue_free()
	$Join.queue_free()
