extends Area2D

func _on_body_entered(body):
	if body and body.has_method("set_checkpoint"):
		body.set_checkpoint(global_position)
