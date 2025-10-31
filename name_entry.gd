extends CanvasLayer

@onready var name_input: LineEdit = $LineEdit
@onready var start_button: Button = $Button
@onready var game_manager = %GameManager
@onready var player = get_node("../Player") 

func _ready():
	start_button.pressed.connect(_on_start_pressed)
	player.set_physics_process(false)
func _on_start_pressed():
	var text_value = name_input.text.strip_edges()

	if text_value.is_valid_int():
		var group_id = int(text_value)
		if group_id > 0:
			game_manager.group_id = group_id
			player.set_physics_process(true)
			hide()
