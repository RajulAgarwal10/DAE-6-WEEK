extends Area2D

@export var message := "Triggered!"

func _on_body_entered(body):
	if body and body.is_in_group("player"):
		print(message)
