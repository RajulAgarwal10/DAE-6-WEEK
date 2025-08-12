extends "res://state.gd"

var player

func enter(p):
	player = p
	if player.is_on_floor():
		player.switch_state("idle")
		return

	player.can_air_attack = false
	player.enable_attack_hitbox()
	player.animated_sprite.play("jump_kick")

func exit():
	if player:
		player.disable_attack_hitbox()

func handle_input(event):
	pass

func update(delta):
	if not player.animated_sprite.is_playing():
		player.switch_state("jump")
