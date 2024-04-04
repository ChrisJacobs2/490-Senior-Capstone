extends Node2D

# Does the spawner need to cool down?
var cooldown = false

# How many players are inside of the spawner?
var num_players_inside = 0

# 5 second cooldown
var cooldown_timer = 5.0

# script name
var script_name = "Weapon_Spawner.gd: "



var chosen_gun = preload("res://GameLogic/Weapons/PenguinGun.tscn").instantiate()
var gun_name = chosen_gun.get_meta("Name")

func spawn():
	# print(script_name, "weapon spawned")
	# Add an instance of the PenguinGun.tscn
	#as a child of the node called Weapon
	# This can be randomized later
	$Weapon.add_child(chosen_gun)


func collect(player):
	# Stats
	#print(script_name, $Weapon.get_child_count())

	# Remove the gun from the spawner, and emit a signal (to SpawnerLogic.gd)
	if $Weapon.get_child_count() > 0:
		SpawnerSignalManager.give_player_wep.emit(player, gun_name)
		$Weapon.remove_child(chosen_gun)
	else:
		print(script_name, "No children to remove")
		

	# wait cooldown_timer seconds
	await get_tree().create_timer(cooldown_timer).timeout

	# await until num_players_inside == 0
	while num_players_inside > 0:
		await get_tree().create_timer(1.0).timeout
	# respawn the gun
	spawn()
	cooldown = false


# Called when the node enters the scene tree for the first time.
func _ready():
	# Hide the ColorRect
	$ColorRect.hide()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

# Called whenever a "body" including the player enters the collision box of the
# spawner.
func _on_spawner_area_entered(body):
	#print(script_name, "Spawner Area Entered")
	#print(script_name, body)
	
	# We keep track of this incase a player waits inside of a spawner
	if body.is_in_group("player"):
		num_players_inside += 1

		# have the player "collect" the weapon
			# makes sure that the spawner only activates every cooldown_timer seconds
		if cooldown == false:
			cooldown = true
			collect(body)
	
	


func _on_spawner_area_exited(body):
	if body.is_in_group("player"):
		num_players_inside += 1
