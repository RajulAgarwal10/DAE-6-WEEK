extends CanvasLayer

@onready var player_bar := $PlayerHealth
@onready var enemy_bar := $EnemyHealth

func _ready():
	# Setup Player HealthBar
	var bg_tex = GradientTexture2D.new()
	var grad = Gradient.new()
	grad.add_point(0, Color(0.1, 0.1, 0.1))   # dark gray
	grad.add_point(1, Color(0.1, 0.1, 0.1))
	bg_tex.gradient = grad
	player_bar.texture_progress = null
	player_bar.texture_under = bg_tex
	player_bar.texture_over = null

	var fill_tex = GradientTexture2D.new()
	var fill_grad = Gradient.new()
	fill_grad.add_point(0, Color(0.2, 1, 0.2))  # green
	fill_grad.add_point(1, Color(0.2, 1, 0.2))
	fill_tex.gradient = fill_grad
	player_bar.texture_progress = fill_tex

	# Setup Enemy HealthBar
	var enemy_bg = GradientTexture2D.new()
	var enemy_grad = Gradient.new()
	enemy_grad.add_point(0, Color(0.1, 0.1, 0.1))   # dark gray
	enemy_grad.add_point(1, Color(0.1, 0.1, 0.1))
	enemy_bg.gradient = enemy_grad
	enemy_bar.texture_under = enemy_bg

	var enemy_fill_tex = GradientTexture2D.new()
	var enemy_fill_grad = Gradient.new()
	enemy_fill_grad.add_point(0, Color(1, 0.2, 0.2))  # red
	enemy_fill_grad.add_point(1, Color(1, 0.2, 0.2))
	enemy_fill_tex.gradient = enemy_fill_grad
	enemy_bar.texture_progress = enemy_fill_tex
