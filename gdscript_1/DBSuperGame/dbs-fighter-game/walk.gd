extends State
class_name Walk

func enter():
	player.anim.play("walk")

func physics_update(_delta):
	if not (Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right")):
		state_machine.change_state("Idle")
	elif Input.is_action_just_pressed("attack"):
		state_machine.change_state("Attack")
