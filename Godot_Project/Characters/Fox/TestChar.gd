extends CharacterBody2D

@export var coin : PackedScene

@onready var testChar = $Animations
@onready var animations = $Animations/AnimationPlayer
@onready var cam = $Camera2D
@export var speed = 900
@export var gravity = 30
@export var jump_force = 1300
@export var landed = true
@export var coins = 0
@export var direction = 2 #2 is right, 1 is left
@export var directionChange = true

const FULL_HEALTH = 3
@export var health = FULL_HEALTH
var is_alive = true

func _ready():
	update_health_ui()
	update_coins_ui()
	$HealthBar.max_value = FULL_HEALTH
	
	# Only the player with authority over this node has the camera enabled.
	# Everyone else gets it disabled.
	cam.enabled = is_multiplayer_authority()
	animations.play("Idle")
	
func _enter_tree():
	# This node is created with a name (the player's id) when it gets created.
	# This line uses the name to set the character's multiplayer authority (who owns it)
	set_multiplayer_authority(name.to_int())
	
func update_coins_ui():
	$CoinsLabel.text = "Coins: %s" % coins

func update_health_ui():
	set_health_label()
	set_health_bar()
	
func set_health_label():
	$HealthLabel.text = "Health: %s" % health

func set_health_bar():
	$HealthBar.value = health
	
func damage():
	health -= 1
	if health <= 0:
		die()
	update_health_ui()
	
func _physics_process(_delta):
	
	
	if not is_multiplayer_authority():
		return
	
	if Input.is_action_just_pressed("change_weapon"):
		# call the "swap_slots" function in the Inventory child node.
		$Inventory.swap_slots()
		pass
	
	move_and_slide()
	
	if !is_on_floor():
		$StateChart.send_event("in_air")
		landed = false
		velocity.y += gravity
		if velocity.y > 1000:
			velocity.y = 1000
	
	if is_on_floor():
		velocity.y = 0
		if landed == false:
			$StateChart.send_event("landing")
			landed = true
	
	var x_direction = Input.get_axis("move_left", "move_right")
	
	if Input.is_action_pressed("move_left") && !Input.is_action_pressed("move_right") && !Input.is_action_pressed("crouch"):
		$StateChart.send_event("move_left_right")
		velocity.x  = speed * x_direction
		testChar.flip_h = (x_direction == -1)
		if direction != 1:
			direction = 1
			$Inventory.turnAround()
		
	if Input.is_action_pressed("move_right") && !Input.is_action_pressed("move_left") && !Input.is_action_pressed("crouch"):
		$StateChart.send_event("move_left_right")
		velocity.x  = speed * x_direction
		testChar.flip_h = (x_direction == -1)
		if direction != 2:
			direction = 2
			$Inventory.turnAround()
	
	if Input.is_action_pressed("move_left") && Input.is_action_pressed("move_right") && !Input.is_action_pressed("crouch"):
		$StateChart.send_event("release_left_right")
		velocity.x = 0
	
	if Input.is_action_just_released("move_left") || Input.is_action_just_released("move_right") && !Input.is_action_pressed("crouch"):
		$StateChart.send_event("release_left_right")
		velocity.x = 0
		
	if Input.is_action_just_pressed("jump") && is_on_floor() && !Input.is_action_pressed("crouch"):
		$StateChart.send_event("jumping")
		velocity.y = -jump_force
		
	if Input.is_action_pressed("crouch") && is_on_floor():
		velocity.x = 0
		$StateChart.send_event("crouched")
	
	if Input.is_action_just_released("crouch") && is_on_floor():
		$StateChart.send_event("stood_up")
		
	if Input.is_action_just_pressed("change_weapon"):
		# call the "swap_slots" function in the Inventory child node.
		$Inventory.swap_slots()
		pass
		
	if Input.is_action_just_pressed("shoot"):
		if $Inventory/LaserGun.get_meta("Active") == true:
			$Inventory/LaserGun.shoot(2000,180 * direction)
		if $Inventory/PenguinGun.get_meta("Active") == true:
			$Inventory/PenguinGun.shoot(2000,180 * direction)
		pass
	
func _on_idle_state_processing(_delta):
	animations.play("Idle")
	
func _on_dash_state_entered():
	animations.play("Dash")

func _on_jumping_state_entered():
	animations.play("Jump")
	$StateChart.send_event("jumped")
	
func _on_air_state_entered():
	pass

func _on_crouch_state_entered():
	animations.play("Crouch")
	
	# This function should be called by the client when it dies, since health is calculated client side.
# Not the best practice.
'''
Procedure:

#region New Code Region
1.)
_physics_process() is disabled via set_physics_process(false), which means player can't fall or move.
Player collision is disabled somehow (TODO: Find out how)
Bullets are ignored and fly through char (TODO: Find a way to do this)
Player visibility is disabled by using hide() or set_visible(false)
Remove the player's weapons
Call coin dropping function

2.) 
Wait some amount of seconds
Call the respawn function
#endregion
'''
func die():
	print("Died!")
	is_alive = false
	# Disable the player's input
	set_physics_process(false)	
	# TODO: Disable player collision (Make sure this is synced in the multiplayer synchronizer node)
	'''When disabling input via set_physics_process(false), the player doesn't fall.'''

	# TODO: Find a way to make bullets ignore the player

	# Disable player visiblity (Make sure this is synced in the multiplayer synchronizer node)
	hide()
	# Remove the player's weapons
	$Inventory.drop_all_weapons()	# References the Inventory child node
	# Call the coin dropping function
	drop_coins()
	# Wait some amount of seconds. Let's say 5 seconds
	await get_tree().create_timer(5.0).timeout
	# call the respawn function
	respawn()
	pass

'''
Procedure:
#region New Code Region

1.)
Select a random spawn point (TODO: Add better spawn point selection cause random isn't always the best)
Set the player's position to the spawn point (Essentially teleporting them)

2.)
Set player's health to max
Enable visiblity
Enable player collision
Stop ignoring bullets
Enable physics process via set_process(true)
#endregion
'''	

func respawn():
	print("Respawned!")
	is_alive = true
	# Emit the GameHandler's respawn signal
	GameHandler.emit_signal("respawn_me", self)

	# Set player's health to max
	health = FULL_HEALTH
	update_health_ui()
	# Enable visiblity
	show()
	# TODO: Enable player collision

	# TODO: Stop ignoring bullets

	# Enable physics process via set_physics_process(true)
	set_physics_process(true)
	pass

func drop_coins():
	if coins == 0: return
	if coins % 2 != 0: coins = coins + 1
	for i in range(coins / 2):
		var inst = coin.instantiate()
		inst.global_position = Vector2(position.x + 30, position.y + 30)
		get_parent().add_sibling(inst)
	coins = (coins / 2) - 1
	update_coins_ui()

