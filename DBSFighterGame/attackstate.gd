extends State

func enter(player):
	player.animated_sprite.play("attack")

func physics_update(delta):
	# You can freeze player movement while attacking, or add logic here.
	pass

func handle_input(event):
	# Optional: You could block inputs or queue combos here.
	pass
