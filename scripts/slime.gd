extends Node2D

const SPEED = 60
var direction = 1
var is_dead = false

@onready var ray_cast_right = $RayCastRight
@onready var ray_cast_left = $RayCastLeft
@onready var animated_sprite = $AnimatedSprite2D
@onready var hurtbox = $Hurtbox

func _ready():
	hurtbox.connect("area_entered", Callable(self, "_on_hurtbox_area_entered"))
	add_to_group("enemy")

func _process(delta):
	if is_dead:
		return

	if ray_cast_right.is_colliding():
		direction = -1
		animated_sprite.flip_h = true
	if ray_cast_left.is_colliding():
		direction = 1
		animated_sprite.flip_h = false

	position.x += direction * SPEED * delta

func _on_hurtbox_area_entered(area):
	if area.name == "Hitbox":
		take_damage()

func take_damage():
	if is_dead:
		return
	is_dead = true
	animated_sprite.play("dead")
	await get_tree().create_timer(0.4).timeout
	queue_free()
