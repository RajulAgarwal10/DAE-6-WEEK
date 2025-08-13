extends "res://state.gd"

var player

func enter(p):
	player = p
	player.enable_attack_hitbox()
	player.animated_sprite.play("attack")

func update(delta):
	if player.animated_sprite.animation_finished:
		player.switch_state("idle")

func exit():
	player.disable_attack_hitbox()
	player = null

func physics_update(delta):
	pass

func handle_input(event):
	pass
