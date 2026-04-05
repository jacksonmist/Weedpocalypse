class_name ScoreManager extends Node

@onready var ui: UIManager = %UIManager

var displayed_score: int
var score: float
var time: float

func _ready():
	pass

func _process(delta: float) -> void:
	time += delta
	
func update_score():
	ui.update_score(displayed_score)

func add_score(base_value: float):
	var score_to_add = base_value * time
	score += score_to_add
	displayed_score = roundi(score)
	update_score()
