extends Resource

# This script defines the data structure for all weapons. Whenever a weapon is
# created, for example by having your character pick one up, an instance of this
# script can be created and given variables, kind of like a Java class or a C struct.
# Here's some example code for use in a script that creates the weapon.
# var weapon_data1 = WeaponData.new()  # Create an instance of WeaponData.gd
# weapon_data1.weapon_prefab = "res://scenes/pistol.tscn"  # Set prefab path
# weapon_data1.damage = 20
# weapon_data1.fire_rate = 0.5



var weapon_prefab: PackedScene  # Path to the weapon scene (Prefab)
var damage: int                  # Damage dealt by the weapon
var ammo: int = -1               # Maximum ammo capacity (optional, -1 for infinite)
var fire_rate: int             # Rate of fire for the weapon (RPM)
var icon: Texture2D              # Sprite for the weapon icon in the UI

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
