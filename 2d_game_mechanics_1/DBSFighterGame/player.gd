extends CharacterBody2D

@export var speed := 200
@export var jump_force := -400
@export var gravity := 900
@export var fall_limit_y := 1200  # Adjust to match when you fall off screen

@onready var animated_sprite := $AnimatedSprite2D

@onready var states = {
	"idle": load("res://idlestate.gd").new(),
	"walk": load("res://walkstate.gd").new(),
	"jump": load("res://jumpstate.gd").new(),
	"attack": load("res://attackstate.gd").new(),
	"jab": load("res://jabstate.gd").new(),
	"jump_kick": load("res://jump_kickstate.gd").new(),
	"dive_kick": load("res://dive_kickstate.gd").new(),
	"kick": load("res://kickstate.gd").new()
}

var current_state : State = null

func _ready():
	switch_state("idle")

func _unhandled_input(event):
	# Prioritize attack inputs
	if event.is_action_pressed("attack") and current_state != states["attack"]:
		switch_state("attack")
		return

	if event.is_action_pressed("jab") and current_state != states["jab"]:
		switch_state("jab")
		return

	if event.is_action_pressed("jump_kick") and current_state != states["jump_kick"]:
		switch_state("jump_kick")
		return

	if event.is_action_pressed("dive_kick") and current_state != states["dive_kick"]:
		switch_state("dive_kick")
		return

	if event.is_action_pressed("kick") and current_state != states["kick"]:
		switch_state("kick")
		return

	# Pass input to the current state
	if current_state:
		current_state.handle_input(event)

func _process(delta):
	if current_state:
		current_state.update(delta)

	# One-time attack states that should auto-return to movement/idle
	var one_time_states = [
		states["attack"],
		states["jab"],
		states["kick"],
		states["jump_kick"],
		states["dive_kick"]
	]

	if current_state in one_time_states:
		if not animated_sprite.is_playing():
			if is_on_floor():
				if Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
					switch_state("walk")
				else:
					switch_state("idle")
			else:
				switch_state("jump")

	# Check fall limit
	if position.y > fall_limit_y:
		reset_player_position()

func _physics_process(delta):
	var direction = 0

	if Input.is_action_pressed("move_left"):
		direction -= 1
		animated_sprite.flip_h = true
	if Input.is_action_pressed("move_right"):
		direction += 1
		animated_sprite.flip_h = false

	# Horizontal movement
	var vel = velocity
	vel.x = direction * speed

	# Gravity & jump
	if not is_on_floor():
		vel.y += gravity * delta
	elif Input.is_action_just_pressed("jump"):
		vel.y = jump_force
		switch_state("jump")

	velocity = vel
	move_and_slide()

	# Prevent auto-switching during attack states
	if current_state not in [
		states["attack"],
		states["jab"],
		states["kick"],
		states["jump_kick"],
		states["dive_kick"]
	]:
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

func reset_player_position():
	position = Vector2(200, 200)  # Set to your desired respawn point
	velocity = Vector2.ZERO
	switch_state("idle")
