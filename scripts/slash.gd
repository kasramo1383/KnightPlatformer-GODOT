extends Node2D

@onready var anim = $AnimatedSprite2D
@onready var hitbox = $Hitbox

func _ready():
	anim.play("slash")
	anim.connect("animation_finished", Callable(self, "_on_animation_finished"))
	hitbox.connect("area_entered", Callable(self, "_on_hitbox_area_entered"))

func _on_hitbox_area_entered(area):
	print("X0")
	if area.get_parent().is_in_group("enemy"):
		print("X1")
		area.get_parent().take_damage()
		print("X2")

func _on_animation_finished():
	queue_free()
