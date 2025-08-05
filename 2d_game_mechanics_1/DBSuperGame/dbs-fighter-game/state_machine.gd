extends Node
class_name StateMachine

@export var initial_state_path: NodePath
var current_state: State

func _ready():
	current_state = get_node_or_null(initial_state_path)
	if current_state:
		current_state.set_state_machine(self)
		current_state.player = get_parent()
		current_state.enter()

func _physics_process(delta):
	if current_state:
		current_state.physics_update(delta)

func change_state(state_name: String):
	var new_state = get_node_or_null(state_name)
	if not new_state:
		push_warning("State '%s' not found." % state_name)
		return
	current_state.exit()
	current_state = new_state
	current_state.set_state_machine(self)
	current_state.player = get_parent()
	current_state.enter()
