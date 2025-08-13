extends Node2D

@export var max_rounds := 5
@export var enemy_scene: PackedScene
@export var spawn_delay := 2.0

var current_round := 1
var enemies_alive := 0
var round_active := false

@onready var spawn_marker := $Marker2D
@onready var spawn_timer := $Timer
@onready var ui := get_node("../UI/GameUI")

signal round_started(round_number)
signal round_completed(round_number)
signal all_rounds_completed

func _ready():
	if not enemy_scene:
		enemy_scene = preload("res://enemy.tscn")
	
	spawn_timer.wait_time = spawn_delay
	spawn_timer.connect("timeout", Callable(self, "_spawn_next_enemy"))
	
	if ui:
		round_started.connect(ui._on_round_started)
		round_completed.connect(ui._on_round_completed)
		all_rounds_completed.connect(ui._on_all_rounds_completed)
	
	start_round()

func start_round():
	if current_round > max_rounds:
		all_rounds_completed.emit()
		return
	
	round_active = true
	round_started.emit(current_round)
	
	# Calculate enemies for this round
	var enemies_to_spawn = current_round + 1
	enemies_alive = enemies_to_spawn
	
	# Spawn first enemy immediately
	spawn_enemy()
	
	# Schedule remaining enemies
	if enemies_to_spawn > 1:
		spawn_timer.start()

func spawn_enemy():
	var enemy = enemy_scene.instantiate()
	get_parent().add_child(enemy)
	enemy.global_position = spawn_marker.global_position
	enemy.set_round(current_round)
	enemy.enemy_died.connect(_on_enemy_died)

func _spawn_next_enemy():
	enemies_alive -= 1
	if enemies_alive > 0:
		spawn_enemy()
	else:
		spawn_timer.stop()

func _on_enemy_died():
	enemies_alive -= 1
	if enemies_alive <= 0:
		complete_round()

func complete_round():
	round_active = false
	round_completed.emit(current_round)
	current_round += 1
	
	# Delay before next round
	await get_tree().create_timer(3.0).timeout
	start_round()
