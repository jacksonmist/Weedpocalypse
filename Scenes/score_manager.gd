class_name ScoreManager extends Node

@onready var ui: UIManager = %UIManager
var save_path = "user://highscore.save"
var displayed_score: int
var score: float
var high_score: float
var time: float

func _ready():
	load_data()
	ui.load_high_score(high_score)

func _process(delta: float) -> void:
	time += delta
	
func update_score():
	ui.update_score(displayed_score)

func add_score(base_value: float):
	var score_to_add = base_value * time
	score += score_to_add
	displayed_score = roundi(score)
	update_score()

func game_over():
	if(score > high_score):
		high_score = score
		save()
	ui.display_game_over()
func save():
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_var(high_score)

func load_data():
	if(FileAccess.file_exists(save_path)):
		var file = FileAccess.open(save_path,FileAccess.READ)
		high_score = file.get_var(high_score)
	else:
		high_score = 0
