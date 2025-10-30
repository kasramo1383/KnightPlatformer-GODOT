extends Node2D

@export var player: CharacterBody2D  # player reference

@onready var anim = $AnimatedSprite2D
@onready var hitbox = $Hitbox

var has_bounced = false  # ensures only one bounce per slash

func _ready():
	anim.play("slash_down")
	anim.connect("animation_finished", Callable(self, "_on_animation_finished"))
	hitbox.connect("body_entered", Callable(self, "_on_hitbox_body_entered"))

func _on_hitbox_body_entered(body):
	if body.is_in_group("enemy"):
		body.take_damage()

func _on_animation_finished():
	queue_free()
