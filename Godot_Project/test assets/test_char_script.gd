extends CharacterBody2D

@onready var cam = $Camera2D
const SPEED = 600.0
const JUMP_VELOCITY = -1000.0
@export var coins : int

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


	
func _enter_tree():
	# This charcater is assigned a name (player id) when created. In this line,
	# we are basically setting the ownership to the id that is the character's name.
	set_multiplayer_authority(name.to_int())
	# For example, character's name is 1 (host). We set the authority to 1.

func _ready():
	# Enables the camera on this character if we own it
	cam.enabled = is_multiplayer_authority()
	
func _physics_process(delta):
	# We do not want other clients calculating physics for our character.
	if not is_multiplayer_authority():
		return

	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta * 1.5
	
	handle_control()
	

	move_and_slide()

func handle_control():
	# Handle jump.
	if Input.is_action_just_pressed("ui_select") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# Add the quit game functionality
	if Input.is_action_pressed("DEVELOPER_QUIT"):
		get_tree().quit()

	# Drop down functonality
	if Input.is_action_pressed("ui_down") and is_on_floor():
		position.y += 1

	# swap weapon button
	if Input.is_action_just_pressed("change_weapon"):
		# call the "swap_slots" function in the Inventory child node.
		$Inventory.swap_slots()
		pass
	
