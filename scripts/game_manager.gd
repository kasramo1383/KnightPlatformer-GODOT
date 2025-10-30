extends Node

var score = 0

@onready var score_label = $ScoreLabel
var coin_count;


func _ready():
	var coin_node = get_parent().get_node("Coins")
	coin_count = coin_node.get_child_count()
	score_label.text = "Coins: " + str(score) +"/" + str(coin_count)
	
func add_point():
	score += 1
	score_label.text = "Coins: " + str(score) +"/" + str(coin_count)
	if score == coin_count:
		win()
func win():
	print("You won")
