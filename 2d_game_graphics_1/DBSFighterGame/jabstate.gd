extends "res://state.gd"

var player

func enter(p):
	player = p
	player.animated_sprite.play("jab")

func exit():
	pass

func handle_input(event):
	pass

func update(delta):
	pass
