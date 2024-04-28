extends Area2D

@onready var audioS = $AudioStreamPlayer2D

# Called when the node enters the scene tree for the first time.
func _connect() -> void:
	connect("mouse_entered", _on_start_button_pressed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _on_start_button_pressed() -> void:
	print("mouseenter")
	audioS.play(0.0)
