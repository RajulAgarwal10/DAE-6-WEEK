extends Node2D

@export var current_round := 1
@export var max_rounds := 3

var enemy_alive := true  # Set false when enemy dies

func _ready():
	print("Starting round ", current_round)
	# Wait for enemy to die manually or via signal connected from enemy

func on_enemy_died():
	print("Enemy died on round ", current_round)
	enemy_alive = false
	current_round += 1
	if current_round > max_rounds:
		print("All rounds complete! You win!")
		return
	print("Ready for round ", current_round)
	# You can enable next enemy manually or via signals here


func _on_enemy_died() -> void:
	pass # Replace with function body.
