extends State
class_name Idle

func enter():
	player.anim.play("idle")

func physics_update(_delta):
	if Input.is_action_just_pressed("attack"):
		state_machine.change_state("Attack")
	elif Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
		state_machine.change_state("Walk")
