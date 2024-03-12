extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	# Get all spawners in the current scene, then iterate on them.
	var spawners = get_tree().get_nodes_in_group("spawner")
	for spawner in spawners:
		print(spawner)
		spawner.spawn()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
