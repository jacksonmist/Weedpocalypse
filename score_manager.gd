class_name ScoreManager extends Node

@onready var ui: UIManager = %UIManager
var displayed_score: int
var score: float
var combo: int = 1
var combo_raw: float = 0
var high_score: float
var time: float
var is_game_over: bool

var max_combo: float = 11
var combo_steepness: float = 0.05
var combo_midpoint: float = 50
var vertical_offset: float = 1
func _ready():
	load_data()
	ui.load_high_score(high_score)
	is_game_over = false

func _process(delta: float) -> void:
	time += delta
	combo_raw -= (delta)# * combo)
	if(combo_raw < 0):
		combo_raw = 0
	calculate_combo()

func add_score(base_value: float):
	var score_to_add = base_value * time * combo
	score += score_to_add
	combo_raw += base_value
	calculate_combo()
	displayed_score = roundi(score)
	ui.update_score(displayed_score)
	
func calculate_combo():
	var e = exp(1)
	var new_combo = ((max_combo - vertical_offset) / (1 + pow(e, -combo_steepness * (combo_raw - combo_midpoint)))) + 1
	if(new_combo != combo):
		combo = new_combo
		ui.update_combo(combo)
	if(combo < 1):
		combo = 1
	
func reset_combo():
	combo_raw = 0
	calculate_combo()
	
func game_over():
	if(is_game_over):
		return
	is_game_over = true
	if(LeaderboardManager.check_score(score)):
		ui.submit_highscore(score)
	if(score > high_score):
		high_score = score
		save()
	ui.display_game_over()
	
func save():
	SaveManager.data["highscore"] = high_score
	SaveManager.save_data()

func load_data():
	high_score = SaveManager.data["highscore"]
