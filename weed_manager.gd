class_name WeedManager extends Node

@onready var spawn_timer: Timer = $SpawnTimer
@onready var grid_manager: GridManager = %GridManager
@onready var score_manager: ScoreManager = %ScoreManager
@onready var ui: UIManager = %UIManager
var is_gameover: bool = false

var time: float = 0.0
var difficulty: float = 1

@export var one_width_weeds: Array[PackedScene]
@export var two_width_weeds: Array[PackedScene]
@export var three_width_weeds: Array[PackedScene]

@export var one_width_chance: float = 50
@export var two_width_chance: float = 30
@export var three_width_chance: float = 20

@onready var seen_weeds: Dictionary = {Game_Enums.Weeds.DANDELION: false,
								Game_Enums.Weeds.THISTLE: false,
								Game_Enums.Weeds.LATUS: false,
								Game_Enums.Weeds.TREE: false,
								Game_Enums.Weeds.CORN: false}

var active_weeds = []
@onready var grow_particle: CPUParticles2D = $GrowParticle

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

var tutorial_enabled: bool

func _ready() -> void:
	e = exp(1)
	L = max_difficulty - difficulty
	L2 = max_time_between_spawn - min_time_between_spawn
	spawn_timer.wait_time = max_time_between_spawn
	spawn_timer.timeout.connect(spawn_weed)
	set_process(false)
	load_data()
	await get_tree().process_frame
	for weed in seen_weeds.keys():
		if(seen_weeds[weed]):
			await ui.reveal_identifier(weed)
	
func _process(delta: float) -> void:
	time += delta

func save_data():
	SaveManager.data["seen_weeds"] = seen_weeds
	SaveManager.save_data()
	
func load_data():
	if(SaveManager.data["seen_weeds"].is_empty()):
		save_data()
		return
	var temp = SaveManager.data["seen_weeds"]
	for key in temp.keys():
		seen_weeds[int(key)] = temp[key]

func enable_spawning():
	set_process(true)
	spawn_weed()
	
func spawn_weed():
	calculate_difficulty()
	var random_num = randi_range(30, 100)
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
	if(!is_gameover):
		check_seen(weed_instance.type)
	add_child(weed_instance)
	active_weeds.append(weed_instance)
	weed_instance.init(self, difficulty, spawn_pos, width)
	weed_instance.position = spawn_pos
	grow_particle.position = spawn_pos
	grow_particle.position.y += 8
	grow_particle.emitting = true
	spawn_wait()

func weed_grow(is_growing: bool):
	for weed in active_weeds:
		if weed:
			weed.is_growing = false

func spawn_tutorial_weed():
	tutorial_enabled = true
	var weed = one_width_weeds[0]
	var weed_instance = weed.instantiate()
	add_child(weed_instance)
	check_seen(weed_instance.type)
	active_weeds.append(weed_instance)
	weed_instance.init(self, 1, Vector2(72, 0), 1)
	weed_instance.position = Vector2(72, 0)
	grow_particle.position = Vector2(72, 0)
	grow_particle.emitting = true
	
	return weed_instance

func check_seen(weed_type: Game_Enums.Weeds):
	if(seen_weeds[weed_type]):
		return
	seen_weeds[weed_type] = true
	save_data()
	await ui.reveal_identifier(weed_type)

func calculate_difficulty():
	difficulty = (L / (1 + pow(e, -difficulty_slope * (time - difficulty_midpoint)))) + 1

func spawn_wait():
	var wait_time = -(L2 / (1 + pow(e, -time_decrease_slope * (time - spawn_time_midpoint)))) + 5
	spawn_timer.wait_time = wait_time
	spawn_timer.start()

func remove_weed(weed: Weed):
	var free_pos = int((weed.spawn_pos.x - 8) / 16)
	grid_manager.set_free_position(free_pos)
	if(weed in active_weeds):
		active_weeds.erase(weed)
	weed.queue_free()
	if(tutorial_enabled):
		print("here")
		tutorial_enabled = false
		%TutorialManager.advance_tutorial()

func clear_all_weeds():
	for weed in active_weeds:
		weed.kill()

func update_score(base_score: float):
	score_manager.add_score(base_score)

func game_over():
	is_gameover = true
	score_manager.game_over()
	
func weed_punishment():
	score_manager.reset_combo()
