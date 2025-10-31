extends Area2D

@onready var timer = $Timer
var player;


func _on_body_entered(body):
	print(234)
	if body.name == "Player":
		if not get_node("CollisionShape2D").disabled:
			body.die()
