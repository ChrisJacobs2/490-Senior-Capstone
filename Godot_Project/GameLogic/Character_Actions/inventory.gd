# Author: Christopher Jacobs at UNCG, cmjacobs@uncg.edu
# Desc: This script manages holding, picking up, and switching weapons for
#		characters.

extends Node2D

var active_slot: int = 0
var weapon_slots: Array = []
var weapon1
var weapon2



# Called when the node enters the scene tree for the first time.
func _ready():	
	weapon_slots.resize(2)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


# This function will add a weapon node onto the character's WeaponMount node
func mount_weapon(_weapon):
	pass

# This function will toggle hide on one of the weapons, as well as its 'active' property.
func swap_weapon():
	pass
