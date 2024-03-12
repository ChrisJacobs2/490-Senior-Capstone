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

var active_slot: int = 0

# These are references to the weapon nodes that the player is currently holding
var weapon1
var weapon2



# Called when the node enters the scene tree for the first time.
func _ready():	
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func pickup_weapon(_weapon):
	# If there's no space, drop the held weapon
	# Then, if there is space, add the weapon to the current slot. Otherwise, the free slot.
		# Consider implementing an "auto select" feature that will select the picked up weapon
			# maybe even add a setting for this in the options menu
	# 
	pass

# This function will toggle hide on one of the weapons, as well as its 'active' property.
func swap_weapon():
	pass

func drop_weapon():
	pass
