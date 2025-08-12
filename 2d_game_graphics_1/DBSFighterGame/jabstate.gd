extends "res://state.gd"

var player

func enter(p):
	player = p
	player.enable_attack_hitbox()
	player.animated_sprite.play("jab")

func exit():
	if player:
		player.disable_attack_hitbox()

func handle_input(event):
	pass

func update(delta):
	if not player.animated_sprite.is_playing():
		if player.is_on_floor():
			player.switch_state("idle")
		else:
			player.switch_state("jump")
