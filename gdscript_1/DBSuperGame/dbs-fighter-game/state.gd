extends Node
class_name State

var player: CharacterBody2D
var state_machine: StateMachine

func enter(): pass
func exit(): pass
func physics_update(_delta): pass
func set_state_machine(sm):
	state_machine = sm
