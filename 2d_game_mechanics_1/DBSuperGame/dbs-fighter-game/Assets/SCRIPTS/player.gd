extends CharacterBody2D
class_name Player

@onready var state_machine = $StateMachine
@onready var anim = $AnimationPlayer

var speed = 150.0
var jump_velocity = -300.0
var gravity = 1000.0

func _physics_process(delta):
	velocity.y += gravity * delta
	velocity.x = 0
	if Input.is_action_pressed("move_left"):
		velocity.x = -speed
	elif Input.is_action_pressed("move_right"):
		velocity.x = speed
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y = jump_velocity
	move_and_slide()
