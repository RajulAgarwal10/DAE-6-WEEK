extends "res://state.gd"

var player

func enter(p):
	player = p
	player.animated_sprite.play("dive_kick")

func exit():
	pass

func handle_input(event):
	pass

func update(delta):
	pass
