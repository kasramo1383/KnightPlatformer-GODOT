extends Node2D

@export var player: CharacterBody2D  # player reference

@onready var anim = $AnimatedSprite2D
@onready var hitbox = $Hitbox
@onready var tilemap: TileMap = get_parent().get_parent().get_node("TileMap")
@onready var collision_shape = get_node("Hitbox/CollisionShape2D")

var has_bounced = false  # ensures only one bounce per slash

func _ready():
	anim.play("slash_down")
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
		for y in range(start.y, end.y + 1):
			var coords = Vector2i(x, y)
			var tile_data = tilemap.get_cell_tile_data(1, coords)
			if tile_data:
				var collide = tile_data.get_custom_data("collide")
				print(collide)
				if collide:
					if not has_bounced and player:
						player.velocity.y = player.JUMP_VELOCITY / 1.5  # smaller bounce
						has_bounced = true
						print("bounce made")
						return

#func _physics_process(delta: float) -> void:
	#for i in get_slide_collision_count():
		#var collision = get_slide_collision(i)
		#
		## Check if we hit a TileMap
		#if collision.get_collider() is TileMap:
			#var tilemap = collision.get_collider() as TileMap
		  #
		  ## Convert collision point to tile coordinates
			#var tile_coords = tilemap.local_to_map(collision.get_position())
		  #
		  ## Get the TileData for that tile (layer 0 by default)
			#var tile_data = tilemap.get_cell_tile_data(1, tile_coords)
			#if tile_data:
			## Read custom metadata
				#var is_collidable = tile_data.get_custom_data("collide")
			#
				#if is_collidable:
					#if not has_bounced and player:
						#player.velocity.y = player.JUMP_VELOCITY / 1.5  # smaller bounce
						#has_bounced = true
						#print("bounce made")
					#

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
