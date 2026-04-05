class_name WeedManager extends Node

@onready var spawn_timer: Timer = $SpawnTimer
@onready var grid_manager: GridManager = %GridManager
@onready var score_manager: ScoreManager = %ScoreManager

var time: float = 0.0
var difficulty: float = 1

@export var one_width_weeds: Array[PackedScene]
@export var two_width_weeds: Array[PackedScene]
@export var three_width_weeds: Array[PackedScene]

@export var one_width_chance: float = 50
@export var two_width_chance: float = 30
@export var three_width_chance: float = 20

var e: float
var max_difficulty: float = 2.0
var L: float
var difficulty_slope: float = 0.1
var difficulty_midpoint: float = 30

var max_time_between_spawn: float = 5
var min_time_between_spawn: float = 1
var L2: float
var time_decrease_slope: float = 0.1
var spawn_time_midpoint: float = 30

func _ready() -> void:
	e = exp(1)
	L = max_difficulty - difficulty
	L2 = max_time_between_spawn - min_time_between_spawn
	spawn_timer.wait_time = max_time_between_spawn
	spawn_timer.timeout.connect(spawn_weed)
	spawn_weed()
	
func _process(delta: float) -> void:
	time += delta
	calculate_difficulty()

func spawn_weed():
	var random_num = 50 #randi_range(1, 100)
	var width: int = 1
	var weed: PackedScene
	if(random_num >= one_width_chance):
		width = 1
		weed = one_width_weeds.pick_random()
	elif(random_num < one_width_chance and random_num >= two_width_chance):
		width = 2
		weed = two_width_weeds.pick_random()
	else:
		width = 3
		weed = three_width_weeds.pick_random()
	if(weed == null):
		weed = one_width_weeds.pick_random()	
	var spawn_pos = grid_manager.get_free_point(width)
	if(spawn_pos == null):
		spawn_wait()
		return
	var weed_instance = weed.instantiate()
	add_child(weed_instance)
	weed_instance.init(self, difficulty, spawn_pos, width)
	weed_instance.position = spawn_pos
	spawn_wait()

func calculate_difficulty():
	difficulty = (L / (1 + pow(e, -difficulty_slope * (time - difficulty_midpoint)))) + 1

func spawn_wait():
	var wait_time = -(L2 / (1 + pow(e, -time_decrease_slope * (time - spawn_time_midpoint)))) + 5
	spawn_timer.wait_time = wait_time
	spawn_timer.start()

func remove_weed(weed: Weed):
	var free_pos = int((weed.spawn_pos.x - 8) / 16)
	grid_manager.set_free_position(free_pos)
	weed.queue_free()

func update_score(base_score: float):
	score_manager.add_score(base_score)
