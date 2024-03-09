extends Node2D

func spawn():
	print("spawn")
	# Add an instance of the PenguinGun.tscn (located in res://GameLogic/Weapons/PenguinGun.tscn)
	 #as a child of the node called Weapon
	# This can be randomized later
	var penguin_gun = preload("res://GameLogic/Weapons/PenguinGun.tscn").instantiate()
	$Weapon.add_child(penguin_gun)
	pass
	


# Called when the node enters the scene tree for the first time.
func _ready():
	# Hide the ColorRect
	$ColorRect.hide()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass





func _on_spawner_area_entered(body):
	print("Spawner Area Entered")
	print(body)
	pass # Replace with function body.
