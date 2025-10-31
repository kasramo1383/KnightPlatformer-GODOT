extends Node

var score = 0
var group_id: int = 0
@onready var score_label = $ScoreLabel
@onready var win_label = $WinLabel
var coin_count;


func _ready():
	var coin_node = get_parent().get_node("Coins")
	coin_count = coin_node.get_child_count()
	score_label.text = "Coins: " + str(score) +"/" + str(coin_count)
	win_label.hide()
	
func add_point():
	score += 1
	score_label.text = "Coins: " + str(score) +"/" + str(coin_count)
	if score == coin_count:
		win()
		
func win():
	win_label.text = "You won! Hash for team %d: %s" % [group_id, generate_hash(group_id, "SECRET")]
	win_label.show()
	
func generate_hash(solver_group_id: int, private_key: String) -> String:
	var combined := str(solver_group_id) + ":" + private_key
	var raw := combined.sha256_buffer()
	var b64 := Marshalls.raw_to_base64(raw)
	b64 = b64.replace("+", "-").replace("/", "_").replace("=", "")
	if b64.length() >= 10:
		return b64.substr(0, 10)
	else:
		return b64 + "-".repeat(10 - b64.length())
