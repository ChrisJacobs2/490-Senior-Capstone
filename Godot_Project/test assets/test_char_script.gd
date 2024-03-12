extends CharacterBody2D


const SPEED = 600.0
const JUMP_VELOCITY = -1000.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta * 1.5

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

	move_and_slide()
