extends Control

@onready var player_health_bar := $PlayerHealthContainer/PlayerHealthBar
@onready var enemy_health_bar := $EnemyHealthContainer/EnemyHealthBar
@onready var enemy_health_container := $EnemyHealthContainer
@onready var round_label := $RoundContainer/RoundLabel
@onready var round_status_label := $RoundContainer/RoundStatusLabel
@onready var combo_label := $ComboContainer/ComboLabel
@onready var combo_multiplier_label := $ComboContainer/ComboMultiplierLabel
@onready var game_over_screen := $GameOverScreen
@onready var victory_screen := $VictoryScreen
@onready var restart_button := $GameOverScreen/GameOverContainer/RestartButton

var health_bar_shake_timer := 0.0
var original_health_pos: Vector2

func _ready():
	enemy_health_container.visible = false
	game_over_screen.visible = false
	victory_screen.visible = false
	
	if restart_button:
		restart_button.connect("pressed", Callable(self, "_on_restart_pressed"))
	original_health_pos = player_health_bar.position


func _on_player_health_changed(health):
	player_health_bar.value = health
	var tween = create_tween()
	tween.tween_property(player_health_bar, "value", health, 0.3)
	if health < player_health_bar.value:
		shake_health_bar()
	if health <= 1:
		flash_health_bar()

func shake_health_bar():
	health_bar_shake_timer = 0.3
	var tween = create_tween()
	for i in range(5):
		tween.tween_property(player_health_bar, "position", 
			original_health_pos + Vector2(randf_range(-5, 5), randf_range(-5, 5)), 0.05)
	tween.tween_property(player_health_bar, "position", original_health_pos, 0.1)

func flash_health_bar():
	var tween = create_tween()
	tween.set_loops(3)
	tween.tween_property(player_health_bar, "modulate", Color.RED, 0.2)
	tween.tween_property(player_health_bar, "modulate", Color.WHITE, 0.2)

func _on_enemy_health_changed(health, max_health):
	enemy_health_container.visible = true
	enemy_health_bar.max_value = max_health
	enemy_health_bar.value = health

func _on_enemy_died():
	enemy_health_container.visible = false

func _on_player_combo_changed(combo, multiplier):
	combo_label.text = "Combo: " + str(combo)
	combo_multiplier_label.text = "x" + str(multiplier).pad_decimals(1)
	
	# Combo popup effect
	if combo > 0:
		var tween = create_tween()
		tween.set_parallel(true)
		combo_label.scale = Vector2(1.5, 1.5)
		combo_multiplier_label.scale = Vector2(1.5, 1.5)
		
		tween.tween_property(combo_label, "scale", Vector2(1, 1), 0.3)
		tween.tween_property(combo_multiplier_label, "scale", Vector2(1, 1), 0.3)
		
		# Color based on combo level
		if combo >= 10:
			combo_label.modulate = Color.GOLD
		elif combo >= 5:
			combo_label.modulate = Color.ORANGE  
		else:
			combo_label.modulate = Color.WHITE
			



func _on_special_meter_changed(meter):
	# Add special meter bar if needed
	pass

func _on_round_started(round_number):
	round_label.text = "Round: " + str(round_number)
	round_status_label.text = "Fight!"

func _on_round_completed(round_number):
	round_status_label.text = "Round " + str(round_number) + " Complete!"

func _on_all_rounds_completed():
	victory_screen.visible = true

func show_game_over():
	game_over_screen.visible = true

func _on_restart_pressed():
	get_tree().reload_current_scene()
