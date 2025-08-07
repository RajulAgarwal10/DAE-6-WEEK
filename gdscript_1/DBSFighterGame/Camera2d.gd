extends Camera2D

# Set these to your background/world bounds (adjust if your world is larger)
@export var world_limit_left := 0
@export var world_limit_top := 0
@export var world_limit_right := 1920
@export var world_limit_bottom := 1080

func _ready():
	limit_left = world_limit_left
	limit_top = world_limit_top
	limit_right = world_limit_right
	limit_bottom = world_limit_bottom

	# Optional: Make camera follow more smoothly
	smoothing_enabled = true
	smoothing_speed = 5.0

	# Force it to start current camera
	current = true
