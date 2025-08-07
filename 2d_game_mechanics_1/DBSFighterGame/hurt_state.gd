extends "res://state.gd"

func enter(player):
	player.animated_sprite.play("hurt")

func handle_input(event):
	pass  # Prevent input while hurt

func update(delta):
	if not player.animated_sprite.is_playing():
		player.switch_state("idle")
