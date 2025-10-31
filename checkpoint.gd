extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _on_body_entered(body):
	print("sdfafdl;as;lklkdfj")
	if body.name != "Player":
		return
	body.set_checkpoint()
	
