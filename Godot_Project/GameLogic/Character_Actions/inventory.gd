# Author: Christopher Jacobs at UNCG, cmjacobs@uncg.edu
# Desc: This script manages holding, picking up, and switching weapons for
#		characters.

extends Node2D

var weaponDataArray: Array = []	# Should only have two slots, but I'll leave it as an array incase we want to increase the capacity later.

# Called when the node enters the scene tree for the first time.
func _ready():
	# Here's how to create instances of WeaponData.gd and add them to the array
	# var weaponData1 = WeaponData.new()
	# weaponDataArray.append(weaponData1)

	# If the charcater starts with a weapon, we might want to add them based on
	# The character's starting weapon variable, if it has one.
	# For example, get a character node as a variable and then
	# figure out the starting weapon using that information, then "equip" it here.
	
	
	# How to access the properties of the weapon data instances
	# print(weaponDataArray[0].fire_rate)
	# print(weaponDataArray[1].damage)
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
