extends Node2D

const SPEED = 60
const RANGE = 100  # distance to oscillate from start point
var direction = 1
var is_dead = false
var start_position: Vector2

var time := 0.0
const AMPLITUDE := 10.0
const FREQUENCY := 2.0

@onready var animated_sprite = $AnimatedSprite2D
@onready var hurtbox = $Hurtbox

func _ready():
	hurtbox.connect("area_entered", Callable(self, "_on_hurtbox_area_entered"))
	add_to_group("enemy")
	start_position = position

func _process(delta):
	if is_dead:
		return

	position.x += direction * SPEED * delta
	time += delta
	position.y = start_position.y + sin(time * FREQUENCY) * AMPLITUDE

	# Flip direction if reaching limits
	if position.x > start_position.x + RANGE:
		direction = -1
		animated_sprite.flip_h = true
	elif position.x < start_position.x - RANGE:
		direction = 1
		animated_sprite.flip_h = false

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
