extends "res://state.gd"

var player

func enter(p):
	player = p
	# safety: allow entering only if airborne
	if player.is_on_floor():
		# abort back to idle if somehow triggered on ground
		player.switch_state("idle")
		return

	# consume the air attack
	player.can_air_attack = false
	player.enable_attack_hitbox()
	player.animated_sprite.play("jump_kick")

func exit():
	if player:
		player.disable_attack_hitbox()

func handle_input(event):
	pass

func update(delta):
	pass
