extends Timer

var clients_ready = 0

# Called when the node enters the scene tree for the first time.
func _ready():

	# If we are the host
	if MS.is_server():
		# Connect to the start_the_timer signal
		GameHandler.connect("start_the_timer", _on_start_timer)
		
		GameHandler.run_match() # hotfix A. starts the game immediately.
	else:
		# Make an RPC call to the host to let them know we are ready
		#player_is_ready.rpc_id(1)	# hotfix A
		pass
	




func _on_timeout():
	GameHandler.emit_signal("timer_is_done")



# Start the timer using its defined wait time in the scene menu
func start_timer():
	# self.start(30)
	self.start(wait_time)


# This is called by the Game_Handler script once the 3 seconds contdown is over
func _on_start_timer():
	start_timer()

# This gets RPC'd by a player when they are loaded into the map.
@rpc("any_peer", "call_remote", "reliable")
func player_is_ready():
	clients_ready += 1
	# If the number of clients ready is equal to the number of connected players
	if clients_ready == MS.num_players:
		# Run the match
		GameHandler.run_match()
	pass

