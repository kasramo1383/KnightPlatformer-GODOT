extends Node2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var kz: Area2D = $Killzone
@onready var kz_shape: CollisionShape2D = $Killzone/CollisionShape2D

@export var cycle_time: float = 20.0                # seconds for full up+down
@export var damage_frames: Array[int] = [2, 3, 4, 5]  # frames when tips are up

func _ready() -> void:
  # play your 8-frame loop
  sprite.play("up_down")
  # set speed so the whole cycle lasts cycle_time seconds
  var frames := sprite.sprite_frames.get_frame_count("up_down")
  sprite.speed_scale = float(frames) / cycle_time
  set_process(true)

func _process(_dt: float) -> void:
  var active := sprite.frame in damage_frames
  kz_shape.disabled = not active
  kz.monitoring = active
  kz.monitorable = active
