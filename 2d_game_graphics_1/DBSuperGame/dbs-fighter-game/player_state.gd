# player_state.gd
extends State
class_name PlayerState

func enter() -> void:
	player.velocity = Vector2.ZERO
