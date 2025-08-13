extends Node

var camera: Camera2D
var shake_intensity := 0.0
var shake_duration := 0.0
var original_position: Vector2

func _ready():
	camera = get_tree().get_first_node_in_group("camera")
	if not camera:
		camera = get_viewport().get_camera_2d()
	if camera:
		original_position = camera.position

func _process(delta):
	if shake_duration > 0:
		shake_duration -= delta
		if camera:
			camera.position = original_position + Vector2(
				randf_range(-shake_intensity, shake_intensity),
				randf_range(-shake_intensity, shake_intensity)
			)
	else:
		if camera:
			camera.position = original_position

func shake_camera(intensity: float, duration: float):
	shake_intensity = intensity
	shake_duration = duration
