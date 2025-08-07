extends "res://state.gd"

func enter(player):
	player.animated_sprite.play("jump")

func physics_update(delta):
	pass
