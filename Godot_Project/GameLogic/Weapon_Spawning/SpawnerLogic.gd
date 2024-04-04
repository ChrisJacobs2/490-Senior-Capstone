extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	SpawnerSignalManager.give_player_wep.connect(on_spawner_collision)

	# Get all spawners in the current scene, then iterate on them.
	var spawners = get_tree().get_nodes_in_group("random_spawner")
	for spawner in spawners:
		spawner.spawn()


# This is called whenever a player walks into the Area2D box of a spawner.
# player is the node reference of the player, weapon is the metadata name of the weapon.
func on_spawner_collision(player, weapon):
	# Get the Inventory child node of the player
	var inventory = player.get_node("Inventory")
	
	# call the translate_instructions() function of the Inventory node, passing the weapon metadata name.
	inventory.translate_instructions(weapon)

	pass
