extends GPUParticles2D

func _ready():
	emitting = true
	# Auto-delete after effect finishes
	await get_tree().create_timer(lifetime + 0.5).timeout
	queue_free()
