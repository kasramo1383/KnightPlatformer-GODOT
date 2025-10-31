extends Node2D

@onready var anim = $AnimatedSprite2D
@onready var hitbox = $Hitbox
@onready var sfx_slash = $AnimatedSprite2D/AudioStreamPlayer2D
@onready var sfx_hit = $Hitbox/AudioStreamPlayer2D


func _ready():
	anim.play("slash")
	sfx_slash.play()
	anim.connect("animation_finished", Callable(self, "_on_animation_finished"))
	hitbox.connect("area_entered", Callable(self, "_on_hitbox_area_entered"))

func _on_hitbox_area_entered(area):
	if area.get_parent().is_in_group("enemy"):
		sfx_hit.play()
		area.get_parent().take_damage()

func _on_animation_finished():
	queue_free()
