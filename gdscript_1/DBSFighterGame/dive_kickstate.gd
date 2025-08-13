extends "res://state.gd"

var player

func enter(p):
	player = p
	# must be in air and falling to dive
	if player.is_on_floor():
		player.switch_state("idle")
		return
	# optional: require falling to dive
	if player.velocity.y <= 0:
		# if you want to force falling only, abort
		# player.switch_state("jump")
		# return
		pass

	player.can_air_attack = false
	player.enable_attack_hitbox()
	# force a downward velocity so it really dives (tweak value)
	player.velocity.y = 700
	player.animated_sprite.play("dive_kick")

func exit():
	if player:
		player.disable_attack_hitbox()

func handle_input(event):
	pass

func update(delta):
	pass
