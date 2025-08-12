extends CharacterBody2D

@export var base_health := 5
@export var base_speed := 100
@export var base_damage := 1
@export var gravity := 900
@export var follow_range := 400
@export var attack_range := 50

var _round: int = 1
var health := 0
var speed := 0
var damage := 0

var player = null

@onready var animated_sprite := $AnimatedSprite2D
@onready var attack_hitbox := $AttackHitbox

var moving_right := true
var start_position := Vector2.ZERO

func _ready():
	start_position = global_position
	_update_stats()
	animated_sprite.play("idle")
	player = get_tree().get_first_node_in_group("player")
	if player == null:
		push_error("Enemy: Player node not found! Make sure player is in 'player' group.")

	attack_hitbox.body_entered.connect(_on_attack_hitbox_body_entered)
	attack_hitbox.monitoring = false

func set_round(value: int) -> void:
	_round = value
	_update_stats()

func get_round() -> int:
	return _round

func _update_stats() -> void:
	health = base_health + (_round - 1) * 2
	speed = base_speed + (_round - 1) * 20
	damage = base_damage + (_round - 1)

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.y = 0

	if player:
		var dist = global_position.distance_to(player.global_position)
		if dist <= attack_range:
			velocity.x = 0
			if animated_sprite.animation != "punch":
				animated_sprite.play("punch")
			attack_hitbox.monitoring = true
		elif dist <= follow_range:
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
			attack_hitbox.monitoring = false
		else:
			_patrol()
			attack_hitbox.monitoring = false
	else:
		velocity.x = 0
		if animated_sprite.animation != "idle":
			animated_sprite.play("idle")
		attack_hitbox.monitoring = false

	move_and_slide()

func _patrol():
	if moving_right:
		velocity.x = speed
		animated_sprite.flip_h = false
		attack_hitbox.position.x = abs(attack_hitbox.position.x)
		if global_position.x > start_position.x + 150:
			moving_right = false
	else:
		velocity.x = -speed
		animated_sprite.flip_h = true
		attack_hitbox.position.x = -abs(attack_hitbox.position.x)
		if global_position.x < start_position.x - 150:
			moving_right = true

	if animated_sprite.animation not in ["walk", "punch"]:
		animated_sprite.play("walk")

func take_damage(amount):
	health -= amount
	if health <= 0:
		queue_free()
	else:
		animated_sprite.play("hurt")

func _on_attack_hitbox_body_entered(body):
	if body.is_in_group("player") and animated_sprite.animation == "punch":
		body.take_damage(damage)
