extends CharacterBody2D

@export var speed := 200
@export var jump_force := -400
@export var gravity := 900
@export var fall_limit_y := 1200
@export var max_health := 5
@export var attack_cooldown := 0.5

@onready var animated_sprite := $AnimatedSprite2D
@onready var attack_hitbox := $AttackHitbox
@onready var ui := get_node("../UI/GameUI")

@onready var states = {
	"idle": load("res://idlestate.gd").new(),
	"walk": load("res://walkstate.gd").new(),
	"jump": load("res://jumpstate.gd").new(),
	"attack": load("res://attackstate.gd").new(),
	"jab": load("res://jabstate.gd").new(),
	"jump_kick": load("res://jump_kickstate.gd").new(),
	"dive_kick": load("res://dive_kickstate.gd").new(),
	"kick": load("res://kickstate.gd").new(),
	"special": load("res://specialstate.gd").new()
}

var current_state : State = null
var health := max_health
var last_checkpoint_position : Vector2
var can_air_attack : bool = true
var _was_on_floor : bool = true
var _attack_hitbox_default_x := 0.0
var _attack_timer := 0.0

# Combo system
var combo_count := 0
var combo_timer := 0.0
var combo_timeout := 2.0
var combo_multiplier := 1.0

# Special move system
var special_meter := 0.0
var max_special_meter := 100.0

signal health_changed(new_health)
signal combo_changed(combo, multiplier)
signal special_meter_changed(meter)

func _ready():
	last_checkpoint_position = global_position
	switch_state("idle")
	attack_hitbox.monitoring = false
	_attack_hitbox_default_x = attack_hitbox.position.x
	add_to_group("player")
	attack_hitbox.connect("body_entered", Callable(self, "_on_attack_hitbox_body_entered"))
	
	# Connect UI signals
	health_changed.connect(ui._on_player_health_changed)
	combo_changed.connect(ui._on_player_combo_changed)
	special_meter_changed.connect(ui._on_special_meter_changed)

func _process(delta):
	if _attack_timer > 0:
		_attack_timer -= delta
	
	# Handle combo timer
	if combo_timer > 0:
		combo_timer -= delta
		if combo_timer <= 0:
			reset_combo()

	if current_state:
		current_state.update(delta)

	# Auto-return logic for one-time states
	var one_time_states = [
		states["attack"], states["jab"], states["kick"],
		states["jump_kick"], states["dive_kick"], states["special"]
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

	# State switching logic
	if current_state not in [
		states["attack"], states["jab"], states["kick"],
		states["jump_kick"], states["dive_kick"], states["special"]
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

	# Special move
	if event.is_action_pressed("special") and special_meter >= 50.0:
		switch_state("special")
		special_meter -= 50.0
		special_meter_changed.emit(special_meter)
		_attack_timer = attack_cooldown
		return

	# Air attacks
	if event.is_action_pressed("jump_kick") and not is_on_floor() and can_air_attack:
		switch_state("jump_kick")
		_attack_timer = attack_cooldown
		return

	if event.is_action_pressed("dive_kick") and not is_on_floor() and velocity.y > 0 and can_air_attack:
		switch_state("dive_kick")
		_attack_timer = attack_cooldown
		return

	# Ground attacks
	if event.is_action_pressed("attack"):
		switch_state("attack")
		_attack_timer = attack_cooldown
		return

	if event.is_action_pressed("jab"):
		switch_state("jab")
		_attack_timer = attack_cooldown
		return

	if event.is_action_pressed("kick"):
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
	
	# Flash effect
	var tween = create_tween()
	animated_sprite.modulate = Color.RED
	tween.tween_property(animated_sprite, "modulate", Color.WHITE, 0.2)
	
	if health <= 0:
		die() # or queue_free() for enemies
	else:
		animated_sprite.play("hurt")

func die():
	ui.show_game_over()

func respawn():
	global_position = last_checkpoint_position
	velocity = Vector2.ZERO
	health = max_health
	reset_combo()
	special_meter = 0.0
	health_changed.emit(health)
	special_meter_changed.emit(special_meter)
	switch_state("idle")

func set_checkpoint(pos: Vector2):
	last_checkpoint_position = pos

func add_combo():
	combo_count += 1
	combo_timer = combo_timeout
	combo_multiplier = 1.0 + (combo_count * 0.1)
	combo_changed.emit(combo_count, combo_multiplier)
	
	# Add special meter
	special_meter = min(special_meter + 10.0, max_special_meter)
	special_meter_changed.emit(special_meter)

func reset_combo():
	combo_count = 0
	combo_multiplier = 1.0
	combo_changed.emit(combo_count, combo_multiplier)

func enable_attack_hitbox():
	var x = abs(_attack_hitbox_default_x) * (-1 if animated_sprite.flip_h else 1)
	attack_hitbox.position.x = x
	attack_hitbox.monitoring = true

func disable_attack_hitbox():
	attack_hitbox.monitoring = false

func _on_attack_hitbox_body_entered(body):
	if body and body.has_method("take_damage"):
		var damage = int(1 * combo_multiplier)
		body.take_damage(damage)
		add_combo()
		
		# Visual effects
		var screen_shake = get_node("../ScreenShake")
		if screen_shake:
			screen_shake.shake_camera(5.0, 0.1)
		
		var hit_effects = get_node("../HitEffects")  
		if hit_effects:
			hit_effects.create_hit_spark(body.global_position)
			hit_effects.create_damage_number(body.global_position + Vector2(0, -50), damage, combo_count > 3)
			hit_effects.hit_freeze(0.05)
