extends Node2D

@export var player: CharacterBody2D  # player reference

@onready var anim = $AnimatedSprite2D
@onready var hitbox = $Hitbox

var has_bounced = false  # ensures only one bounce per slash

func _ready():
	anim.play("slash_down")
	anim.connect("animation_finished", Callable(self, "_on_animation_finished"))
	hitbox.connect("area_entered", Callable(self, "_on_hitbox_area_entered"))

func _on_hitbox_area_entered(area):
	print("0")
	if area.get_parent().is_in_group("enemy"):
		print("1")
		area.get_parent().take_damage()
		print("2")
		
		# Simple jump effect on the player
		if not has_bounced and player:
			player.velocity.y = player.JUMP_VELOCITY / 1.5  # smaller bounce
			has_bounced = true
			print("bounce made")

func _on_animation_finished():
	queue_free()
