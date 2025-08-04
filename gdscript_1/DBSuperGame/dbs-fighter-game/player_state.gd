class_name PlayerState
extends State

@onready var player: Player = get_tree().get_first_node_in_group("Player")

#Animation Names
var idle_anim: String = "Idle"

func enter() -> void:
	print("Entering PlayerState")
