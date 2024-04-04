extends Node2D

@onready var timer = $MoneyTimer

@export var money_amount = 1

@export var money_interval = 0.5

var players_inside = []

var active = true

# Client side variable to keep track of whether the vault is giving money to the player.
# This is only changed client side, because money is handled client side.
var giving_money = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called when a body (players, tilemap, etc) enters the vault's Area2D
func _on_area_2d_body_entered(body):
	if body.is_in_group("player") && active:
		timer.start(money_interval)
		players_inside.append(body)



# Called when a body (players, tilemap, etc) enters the vault's Area2D
func _on_area_2d_body_exited(body):
	if body.is_in_group("player"):
		timer.stop()
		# If this throws an error, either check before erasing or use a dictionary instead of a list.
		players_inside.erase(body)


# Triggers when the timer is done. Change the amount and frequency in the editor
func _on_money_timer_timeout():
	for player in players_inside:
		# We assume player is a character node with TestChar.gd script attached.
		player.coins += money_amount
		# Since we already have a reference to the player's node, we can just call one of its functions.
		print("vaults.gd: ", player.coins)
		if player.has_method("update_coins_ui"):
			player.update_coins_ui()
		else:
			print("Vaults.gd Error: Player does not have the method 'update_coins_ui'")
