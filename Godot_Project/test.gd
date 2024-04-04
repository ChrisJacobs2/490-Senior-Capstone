extends Node2D

@onready var GunTest = $Gun

func _physics_process(_delta):
	if Input.is_action_pressed("shoot"):
		GunTest.shoot(20,0)
