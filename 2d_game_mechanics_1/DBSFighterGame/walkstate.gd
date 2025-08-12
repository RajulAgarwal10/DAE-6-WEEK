extends "res://state.gd"

func enter(player):
	player.animated_sprite.play("walk")

func physics_update(delta):
	pass
