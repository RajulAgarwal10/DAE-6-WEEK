extends State
class_name Attack

var duration = 0.5

func enter():
	player.anim.play("attack")
	await get_tree().create_timer(duration).timeout
	state_machine.change_state("Idle")
