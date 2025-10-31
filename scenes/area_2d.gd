extends Area2D

func _on_body_entered(body):
	print("gained power up")
	if body.name == "Player":
		body.gain_double_jump()
