extends Timer

var players_ready = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	# If we are the host
	if MS.is_server():
		# Connect to the start_the_timer signal
		GameHandler.connect("start_the_timer", _on_start_timer)

		
	else:
		# Make an RPC call to the host to let them know we are ready
		pass
		


# Start the timer using its defined wait time in the scene menu
func start_timer():
	# self.start(30)
	self.start(wait_time)

# This is called by the Game_Handler script once the 3 seconds contdown is over
func _on_start_timer():
	start_timer()

# This gets RPC'd by a player when they are loaded into the map.
func player_is_ready():
	players_ready += 1
	if players_ready == MS.num_players:
		# Run the match
		GameHandler.run_match()
	pass