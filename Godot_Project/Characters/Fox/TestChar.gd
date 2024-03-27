extends CharacterBody2D

@onready var testChar = $Animations
@onready var animations = $Animations/AnimationPlayer
@export var speed = 700
@export var gravity = 30
@export var jump_force = 1000
@export var landed = true
@export var coins = 0

const FULL_HEALTH = 3
@export var health = FULL_HEALTH

func _ready():
	update_health_ui()
	$HealthBar.max_value = FULL_HEALTH
	
func update_health_ui():
	set_health_label()
	set_health_bar()
	
func set_health_label():
	$HealthLabel.text = "Health: %s" % health

func set_health_bar():
	$HealthBar.value = health
	
func damage():
	health -= 1
	if health == 0:
		health = FULL_HEALTH
	update_health_ui()

func _physics_process(_delta):
	
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
		if landed == false:
			animations.stop()
			$StateChart.send_event("landing")
			landed = true
		velocity.y = 0
		
	
	var x_direction = Input.get_axis("move_left", "move_right")
	
	if Input.is_action_pressed("move_left") && !Input.is_action_pressed("move_right") && !Input.is_action_pressed("crouch"):
		$StateChart.send_event("move_left_right")
		velocity.x  = speed * x_direction
		testChar.flip_h = (x_direction == -1)
		
	if Input.is_action_pressed("move_right") && !Input.is_action_pressed("move_left") && !Input.is_action_pressed("crouch"):
		$StateChart.send_event("move_left_right")
		velocity.x  = speed * x_direction
		testChar.flip_h = (x_direction == -1)
	
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
