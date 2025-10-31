extends Area2D

@onready var game_manager = %GameManager
@onready var animation_player = $AnimationPlayer

func _on_body_entered(body):
	if body.name == "Player":
		body.gain_dash()
	animation_player.play("pickup")
