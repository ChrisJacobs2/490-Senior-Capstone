extends Node

var scene_tree = get_tree()

# Called when the node enters the scene tree for the first time.
func _ready():
	SpawnerSignalManager.test.connect(on_test_lol)

	# Get all spawners in the current scene, then iterate on them.
	var spawners = get_tree().get_nodes_in_group("random_spawner")
	for spawner in spawners:
		print(spawner)
		spawner.spawn()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func on_test_lol():
	print("test lol")
