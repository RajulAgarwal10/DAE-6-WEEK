extends CharacterBody2D

@export var base_health := 5
@export var base_speed := 100
@export var base_damage := 1
@export var gravity := 900
@export var follow_range := 400
@export var attack_range := 50

var _round: int = 1
var health := 0
var max_health := 0
var speed := 0
var damage := 0
var player = null

@onready var animated_sprite := $AnimatedSprite2D
@onready var attack_hitbox := $AttackHitbox
@onready var ui := get_node("../../UI/GameUI")

var moving_right := true
var start_position := Vector2.ZERO
var attack_timer := 0.0
var attack_cooldown := 1.0

signal enemy_health_changed(health, max_health)
signal enemy_died

func _ready():
	start_position = global_position
	_update_stats()
	max_health = health
	animated_sprite.play("idle")
	player = get_tree().get_first_node_in_group("player")
	
	if ui:
		enemy_health_changed.connect(ui._on_enemy_health_changed)
		enemy_died.connect(ui._on_enemy_died)
	
	enemy_health_changed.emit(health, max_health)
	
	attack_hitbox.connect("body_entered", Callable(self, "_on_attack_hitbox_body_entered"))
	attack_hitbox.monitoring = false

func set_round(value: int):
	_round = value
	_update_stats()
	max_health = health
	enemy_health_changed.emit(health, max_health)

func _update_stats():
	health = base_health + (_round - 1) * 3
	speed = base_speed + (_round - 1) * 25
	damage = base_damage + (_round - 1)

func _physics_process(delta):
	if attack_timer > 0:
		attack_timer -= delta

	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.y = 0

	if player:
		var dist = global_position.distance_to(player.global_position)
		if dist <= attack_range and attack_timer <= 0:
			velocity.x = 0
			animated_sprite.play("punch")
			attack_hitbox.monitoring = true
			attack_timer = attack_cooldown
		elif dist <= follow_range:
			_follow_player()
			attack_hitbox.monitoring = false
		else:
			_patrol()
			attack_hitbox.monitoring = false
	else:
		_idle()

	move_and_slide()

func _follow_player():
	if player.global_position.x > global_position.x:
		velocity.x = speed
		animated_sprite.flip_h = false
		attack_hitbox.position.x = abs(attack_hitbox.position.x)
	else:
		velocity.x = -speed
		animated_sprite.flip_h = true
		attack_hitbox.position.x = -abs(attack_hitbox.position.x)
	
	if animated_sprite.animation not in ["walk", "punch"]:
		animated_sprite.play("walk")

func _patrol():
	if moving_right:
		velocity.x = speed * 0.5
		animated_sprite.flip_h = false
		if global_position.x > start_position.x + 150:
			moving_right = false
	else:
		velocity.x = -speed * 0.5
		animated_sprite.flip_h = true
		if global_position.x < start_position.x - 150:
			moving_right = true
	
	if animated_sprite.animation != "walk":
		animated_sprite.play("walk")

func _idle():
	velocity.x = 0
	if animated_sprite.animation != "idle":
		animated_sprite.play("idle")
	attack_hitbox.monitoring = false

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
	
	if health <= 0:
		die()
	else:
		animated_sprite.play("hurt")

func die():
	enemy_died.emit()
	queue_free()

func _on_attack_hitbox_body_entered(body):
	if body.is_in_group("player") and animated_sprite.animation == "punch":
		body.take_damage(damage)
