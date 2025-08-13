extends State

func enter(player):
	player.animated_sprite.play("special")
	player.enable_attack_hitbox()

func exit():
	pass

func update(delta):
	pass
