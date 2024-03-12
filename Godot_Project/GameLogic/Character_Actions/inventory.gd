# Author: Christopher Jacobs at UNCG, cmjacobs@uncg.edu
#
# Desc: This script manages holding, picking up, and switching weapons for
#		characters.
#
# Scene explanation: The inventory scene has a Node2D as its root, with a child
#					 for each weapon. Each weapon node is an instanced scene.
#					 Whatever weapons are "held" are stored in weapon1 and weapon2
#					 as references to the nodes. Basically, all of the weapons are
#					 instanced, but only two are "held" at any given time, and only 
#					 one is "active" at any given time. All weapons that aren't active
#					 are hidden. 
#
# Requirements: Make sure that whatever character you place the inventory scene on,
#				that you move the inventory scene marker to where the character's
#				hand is. This is where the weapons will be placed when they are
#				"active".


extends Node2D

var active_slot: int = 1

# These are references to the weapon nodes that the player is currently holding
var weapon1
var weapon2

# This is a reference to the inventory node
var inventory


# Called when the node enters the scene tree for the first time.
func _ready():
	initialize()

	# test code
		# This line of code attempts to set the variable to Inventory's child node, named Lasergun.
	var laser_gun = $LaserGun
	var penguin_gun = $PenguinGun
	var success_l = pickup_weapon(laser_gun)
	print("Laser: ", success_l)
	var success_p = pickup_weapon(penguin_gun)
	print("Penguin: ", success_p)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

# Weapon is a reference to one of the weapon nodes in the inventory. Returns true if
# the pickup was successful, and false if it was not.
func pickup_weapon(weapon):
	if weapon1 != null and weapon2 != null:	# If there's no space,
		return false
	# If the current slot is empty, add the weapon to it. Otherwise, the free slot.
	pickup_helper(weapon)
	update_the_hud()
	return true
		# Consider implementing an "auto select" feature that will select the picked up weapon
			# maybe even add a setting for this in the options menu


func drop_weapon():
	if active_slot == 1:
		deactivate(weapon1)
		weapon1 = null
	elif active_slot == 2:
		deactivate(weapon2)
		weapon2 = null
	update_the_hud()


func initialize():
	# Set the variables
		# self is the node the script is attached to
	inventory = self

	# Iterate over the children of the inventory node and hide them, plus clears the "active" flag.
	for weapon in inventory.get_children():
		deactivate(weapon)

# For the next two functions, weapon is a reference to one of the weapon nodes in the inventory
func activate(weapon):
	if weapon != null:
		weapon.show()
		weapon.set_meta("Active", true)
	else :
		print("Tried to activate a null weapon")

func deactivate(weapon):
	if weapon != null:
		weapon.hide()
		weapon.set_meta("Active", false)
	else:
		print("Tried to deactivate a null weapon")

# Changes the active slot to the one specified. 
func change_slot(swap_to_slot):
	if swap_to_slot == 1:
		active_slot = 1
		deactivate(weapon2)
		activate(weapon1)
	elif swap_to_slot == 2:
		active_slot = 2
		deactivate(weapon1)
		activate(weapon2)
	update_the_hud()

func swap_slots():
	if active_slot == 1:
		change_slot(2)
		print("Swapped to slot 2")
	else:
		change_slot(1)
		print("Swapped to slot 1")

# This function is called by pickup_weapon. It will attempt to add the weapon to the active slot.
# If both slots are somehow full when this function is called, the inactive slot will be overwritten.
# returns the slot that the weapon was added to
func pickup_helper(weapon):
	# If the active slot is empty, then add the weapon to the active slot
	if active_slot == 1:		# if active slot is 1
		if weapon1 == null:		# if slot 1 is free
			weapon1 = weapon	# then add the weapon to slot 1
			activate(weapon1)   # and activate it
			return 1
		else:					# beyond this point we will assume slot 2 is free but not active
			weapon2 = weapon	# add the weapon to slot 2

			# change_slot(2)			# This could potentially be controlled by an option in settings menu. 
								# Basically it would be a "pick up and switch" feature.
			return 2

	# same as above but for slot 2 respectively
	if active_slot == 2:
		if weapon2 == null:
			weapon2 = weapon
			activate(weapon2)
			return 2
		else:
			weapon1 = weapon

			# change_slot(1)

			return 1


func update_the_hud():
	pass
