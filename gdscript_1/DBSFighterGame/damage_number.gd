extends Label

var velocity := Vector2(0, -100)
var life_time := 1.0

func setup(pos: Vector2, damage: int, is_combo: bool = false):
	global_position = pos
	text = str(damage)
	if is_combo:
		modulate = Color.ORANGE
		scale = Vector2(1.5, 1.5)
	
	# Animate
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(self, "global_position", global_position + Vector2(randf_range(-50, 50), -100), life_time)
	tween.tween_property(self, "modulate:a", 0.0, life_time)
	tween.tween_property(self, "scale", Vector2(0.5, 0.5), life_time)
	
	await tween.finished
	queue_free()
