extends CharacterBody2D

@export var speed := 200
@export var jump_force := -400
@export var gravity := 900
@export var fall_limit_y := 1200
@export var max_health := 5
@export var attack_cooldown := 0.5  # seconds between attacks

@onready var animated_sprite := $AnimatedSprite2D
@onready var attack_hitbox := $AttackHitbox

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
var health := max_health
var last_checkpoint_position : Vector2
var can_air_attack : bool = true
var _was_on_floor : bool = true
var _attack_hitbox_default_x := 0.0
var _attack_timer := 0.0

func _ready():
	last_checkpoint_position = global_position
	switch_state("idle")
	attack_hitbox.monitoring = false
	_attack_hitbox_default_x = attack_hitbox.position.x
	add_to_group("player")
	attack_hitbox.body_entered.connect(_on_attack_hitbox_body_entered)

func _process(delta):
	if _attack_timer > 0:
		_attack_timer -= delta

	if current_state:
		current_state.update(delta)

	# one-time attack states auto-return
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

	if global_position.y > fall_limit_y:
		respawn()

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

	velocity = vel
	move_and_slide()

	var on_floor_now = is_on_floor()
	if not _was_on_floor and on_floor_now:
		can_air_attack = true
	_was_on_floor = on_floor_now

	# prevent auto-switching during attack states
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

func _unhandled_input(event):
	if _attack_timer > 0:
		return

	if event.is_action_pressed("jump_kick") and not is_on_floor() and can_air_attack and current_state != states["jump_kick"]:
		switch_state("jump_kick")
		_attack_timer = attack_cooldown
		return

	if event.is_action_pressed("dive_kick") and not is_on_floor() and velocity.y > 0 and can_air_attack and current_state != states["dive_kick"]:
		switch_state("dive_kick")
		_attack_timer = attack_cooldown
		return

	if event.is_action_pressed("attack") and current_state != states["attack"]:
		switch_state("attack")
		_attack_timer = attack_cooldown
		return

	if event.is_action_pressed("jab") and current_state != states["jab"]:
		switch_state("jab")
		_attack_timer = attack_cooldown
		return

	if event.is_action_pressed("kick") and current_state != states["kick"]:
		switch_state("kick")
		_attack_timer = attack_cooldown
		return

	if current_state:
		current_state.handle_input(event)

func switch_state(state_name: String):
	if not states.has(state_name):
		push_error("Invalid state: " + state_name)
		return
	if current_state:
		current_state.exit()
	current_state = states[state_name]
	current_state.enter(self)

func take_damage(amount: int):
	health -= amount
	if health <= 0:
		respawn()
	else:
		animated_sprite.play("hurt")

func respawn():
	global_position = last_checkpoint_position
	velocity = Vector2.ZERO
	health = max_health
	switch_state("idle")

func set_checkpoint(pos: Vector2):
	last_checkpoint_position = pos

func enable_attack_hitbox():
	var x = abs(_attack_hitbox_default_x) * (-1 if animated_sprite.flip_h else 1)
	attack_hitbox.position.x = x
	attack_hitbox.monitoring = true

func disable_attack_hitbox():
	attack_hitbox.monitoring = false

func _on_attack_hitbox_body_entered(body):
	if body and body.has_method("take_damage"):
		body.take_damage(1)
