class_name WeedManager extends Node

var time: float = 0.0
var difficulty: float

@export var one_width_weeds: Array[PackedScene]
@export var two_width_weeds: Array[PackedScene]
@export var three_width_weeds: Array[PackedScene]

@export var one_width_chance: float = 50
@export var two_width_chance: float = 30
@export var three_width_chance: float = 20

func _ready() -> void:
	spawn_weed()
	
func _process(delta: float) -> void:
	time += delta

func spawn_weed():
	var random_num = randi_range(1, 100)
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
	var spawn_pos = %GridManager.get_free_point(width)
	var weed_instance = weed.instantiate()
	add_child(weed_instance)
	print(typeof(weed_instance))
	weed_instance.set_difficulty(difficulty)
	weed_instance.position = spawn_pos
