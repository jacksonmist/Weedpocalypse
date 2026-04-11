class_name GridManager extends Node

@export var tile_size: int

@export var grid_width: int
@export var grid_height: int

var grid = []
var spawn_points = []
func _ready() -> void:
	initialize_grid()

func initialize_grid():
	for x in range(grid_width):
		spawn_points.append(0)
		for y in range(grid_height):
			grid.append(Vector2i(x, y))
			
func get_free_point(width: int):
	print(spawn_points)
	var free_spots = []
	var window = spawn_points.slice(0, width)
	var sum = 0
	for index in window:
		sum += index
	for i in range(spawn_points.size() - width + 1):
		if(sum == 0):
			free_spots.append(i)
		if(i == spawn_points.size() - width):
			break
		sum -= spawn_points[i]
		sum += spawn_points[width + i]
		
	if(free_spots.size() == 0):
		return null
	var chosen_spot = free_spots.pick_random()
	for i in range(chosen_spot, width + chosen_spot):
		spawn_points[i] = 1
	var world_pos: Vector2 = _grid_to_world(Vector2i(chosen_spot, 0))
	match width:
		1:
			return world_pos
		2:
			world_pos.x += 8
			return world_pos
		3:
			world_pos.x += 16
			return world_pos
	
func _grid_to_world(grid_pos: Vector2i):
	var world_pos = (grid_pos * 16)
	world_pos.x += 8
	return world_pos

func set_free_position(pos: float, width):
	var free_pos = int((pos - 8) / 16)
	if(width == 3):
		free_pos -= 1
	for i in width:
		spawn_points[free_pos + i] = 0
	
