extends CharacterBody2D

const SPEED = 130.0
const JUMP_VELOCITY = -270.0
const DASH_SPEED = 300.0
const DASH_TIME = 0.2
const DASH_COOLDOWN = 0.4
const MAX_JUMPS = 2
const ATTACK_COOLDOWN = 0.4 # <-- new constant for attack cooldown

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var sprite_dir = +1

var double_jump = false
var is_dashing = false
var can_dash = false
var dash_reloaded = true
var dash_timer = 0.0
var dash_direction = 0
var jump_count = 0

var can_attack = true # <-- new flag for attack cooldown

var last_checkpoint: Vector2 = Vector2(-520, 80)

@onready var animated_sprite = $AnimatedSprite2D
@onready var timer = $Timer
@onready var collision_shape = $CollisionShape2D
var dead = false
@export var slash_scene: PackedScene
@export var slash_down_scene: PackedScene
func set_checkpoint():
	last_checkpoint = position
	
func die():
	print("You died!")
	animated_sprite.play("death")
	dead =true
	
	set_physics_process(true)
	timer.start()
	
func _physics_process(delta):
	# Handle dash timer
	if is_dashing:
		dash_timer -= delta
		if dash_timer <= 0:
			stop_dash()
		else:
			velocity.x = dash_direction * DASH_SPEED
			move_and_slide()
			return

	# Gravity
	if not is_on_floor():
		velocity.y += gravity * delta
	if dead:
		move_and_slide()
		return

	# Reset jump count when grounded
	if is_on_floor():
		jump_count = 0
		dash_reloaded = true

	# Jump
	if Input.is_action_just_pressed("jump") and jump_count < MAX_JUMPS:
		if double_jump == false and jump_count == 1 or double_jump == false and not is_on_floor():
			pass
		else:
			if not is_on_floor():
				jump_count = 2
			velocity.y = JUMP_VELOCITY
			jump_count += 1
	# Dash
	if Input.is_action_just_pressed("dash") and can_dash and dash_reloaded:
		start_dash()
		return

	# Movement input
	var direction = Input.get_axis("move_left", "move_right")

	# Flip sprite
	if direction > 0:
		sprite_dir = +1
		animated_sprite.flip_h = false
	elif direction < 0:
		sprite_dir = -1
		animated_sprite.flip_h = true

	# Animations
	if not dead:
		if is_on_floor():
			if direction == 0:
				animated_sprite.play("idle")
			else:
				animated_sprite.play("run")
		else:
			animated_sprite.play("jump")

	# Apply horizontal movement
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# Attacks with cooldown
	if Input.is_action_just_pressed("attack") and can_attack:
		var is_down = Input.is_action_pressed("move_down")
		perform_attack(is_down)
		start_attack_cooldown() # <-- triggers cooldown

	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		if collision.get_collider() is TileMap:
			var tilemap = collision.get_collider() as TileMap
			var tile_coords = tilemap.local_to_map(collision.get_position())
			var tile_data = tilemap.get_cell_tile_data(1, tile_coords)
			if tile_data:
				var tile_type = tile_data.get_custom_data("collide")
				var damage = tile_data.get_custom_data("killer")
				if damage and not dead:
					die()

	move_and_slide()


func start_dash():
	dash_reloaded = false
	is_dashing = true
	can_dash = false
	velocity.y = 0
	dash_timer = DASH_TIME
	dash_direction = sprite_dir
	animated_sprite.play("dash")


func stop_dash():
	is_dashing = false
	animated_sprite.play("idle")
	await get_tree().create_timer(DASH_COOLDOWN).timeout
	can_dash = true


# --- NEW FUNCTION ---
func start_attack_cooldown():
	can_attack = false
	await get_tree().create_timer(ATTACK_COOLDOWN).timeout
	can_attack = true
# --------------------


func perform_attack(is_down := false):
	var slash_instance: Node2D
	if is_down:
		if is_on_floor():
			return
		slash_instance = slash_down_scene.instantiate()
		slash_instance.player = self
	else:
		slash_instance = slash_scene.instantiate()
		
	add_child(slash_instance)

	var offset = Vector2(0, 30) if is_down else Vector2(30, 0)
	if animated_sprite.flip_h and not is_down:
		offset.x *= -1
		slash_instance.scale.x = -1
	slash_instance.position = offset


func _on_timer_timeout() -> void:
	Engine.time_scale = 1.0
	
	position = last_checkpoint
	velocity.x = 0
	velocity.y = 0
	set_physics_process(true)
	dead = false

func gain_double_jump() -> void:
	double_jump = true
	
func gain_dash() -> void:
	can_dash = true
