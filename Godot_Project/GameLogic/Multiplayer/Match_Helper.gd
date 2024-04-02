extends Timer

# Called when the node enters the scene tree for the first time.
func _ready():
	# If we are the host
	if MS.is_server():
		# Run the match
		GameHandler.run_match()


func start_timer():
	# Start the timer using its defined wait time in the scene menu
	# self.start(30)
	self.start(wait_time)