extends "res://state.gd"


func enter(player):
	player.animated_sprite.play("idle")

func physics_update(delta):
	# Nothing specific for idle movement
	pass
