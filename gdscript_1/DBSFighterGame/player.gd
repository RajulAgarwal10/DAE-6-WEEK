extends CharacterBody2D

@export var speed := 200
@export var jump_force := -400
@export var gravity := 900

@onready var animated_sprite := $AnimatedSprite2D

@onready var states = {
	"idle": load("res://idlestate.gd").new(),
	"walk": load("res://walkstate.gd").new(),
	"jump": load("res://jumpstate.gd").new(),
	"attack": load("res://attackstate.gd").new()
}

var current_state : State = null

func _ready():
	switch_state("idle")

func _unhandled_input(event):
	# Detect attack input first, switch state immediately
	if event.is_action_pressed("attack") and current_state != states["attack"]:
		switch_state("attack")
		return

	if current_state:
		current_state.handle_input(event)

func _process(delta):
	if current_state:
		current_state.update(delta)

	# If in attack state, check if attack animation finished to return to idle/walk
	if current_state == states["attack"]:
		if not animated_sprite.is_playing():
			# Decide whether to go to walk or idle based on movement keys
			if Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
				switch_state("walk")
			else:
				switch_state("idle")

func _physics_process(delta):
	var direction = 0
	if Input.is_action_pressed("move_left"):
		direction -= 1
		animated_sprite.flip_h = true
	if Input.is_action_pressed("move_right"):
		direction += 1
		animated_sprite.flip_h = false

	var vel = velocity
	vel.x = direction * speed

	if not is_on_floor():
		vel.y += gravity * delta
	elif Input.is_action_just_pressed("jump"):
		vel.y = jump_force
		switch_state("jump")

	self.velocity = vel

	if current_state:
		current_state.physics_update(delta)

	move_and_slide()

	# Handle switching between idle, walk, and jump only if not attacking
	if current_state != states["attack"]:
		if is_on_floor():
			if direction == 0:
				switch_state("idle")
			else:
				switch_state("walk")
		else:
			switch_state("jump")

func switch_state(state_name: String):
	if not states.has(state_name):
		push_error("Invalid state: " + state_name)
		return

	if current_state:
		current_state.exit()
	current_state = states[state_name]
	current_state.enter(self)
