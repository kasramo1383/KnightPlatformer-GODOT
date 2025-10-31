extends Node2D

@export var player: CharacterBody2D  # player reference

@onready var anim = $AnimatedSprite2D
@onready var hitbox = $Hitbox
@onready var sfx_slash = $AnimatedSprite2D/SwordSlashSound
@onready var sfx_hit_enemy = $Hitbox/SwordHitEnemySound
@onready var sfx_hit_spike = $Hitbox/SwordHitSpikeSound
@onready var tilemap: TileMap = get_parent().get_parent().get_node("TileMap")
@onready var collision_shape = get_node("Hitbox/CollisionShape2D")

var has_bounced = false  # ensures only one bounce per slash

func _ready():
	anim.play("slash_down")
	sfx_slash.play()
	anim.connect("animation_finished", Callable(self, "_on_animation_finished"))
	hitbox.connect("area_entered", Callable(self, "_on_hitbox_area_entered"))
	check_tile_collisions()
func check_tile_collisions():
	if not collision_shape or not tilemap:
		return
	
	# Get the shape extents
	var shape = collision_shape.shape
	if not shape or not (shape is RectangleShape2D):
		return
	
	var rect_extents = shape.extents
	var rect_pos = $"..".global_position  # Player’s global position

	# Build the world-space rectangle AABB
	var top_left = rect_pos - rect_extents
	var bottom_right = rect_pos + rect_extents

	# Convert world positions to tile coordinates
	var start = tilemap.local_to_map(top_left)
	var end = tilemap.local_to_map(bottom_right)

	# Loop through all tiles overlapped by the rectangle
	for x in range(start.x, end.x + 1):
		for y in range(start.y, end.y + 2):
			var coords = Vector2i(x, y)
			var tile_data = tilemap.get_cell_tile_data(1, coords)
			if tile_data:
				var collide = tile_data.get_custom_data("collide")
				print(collide)
				if collide:
					sfx_hit_spike.play()
					bounce_player()

func bounce_player():
	if not has_bounced and player:
		player.velocity.y = player.JUMP_VELOCITY
		has_bounced = true
		player.dash_reloaded = true
		return
		
func _on_hitbox_area_entered(area):
	if area.get_parent().is_in_group("enemy"):
		area.get_parent().take_damage()
		sfx_hit_enemy.play()
		# Simple jump effect on the player
		bounce_player()

func _on_animation_finished():
	queue_free()
