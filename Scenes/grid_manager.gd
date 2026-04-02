extends Node

@export var tile_size: int

@export var grid_width: int
@export var grid_height: int

var grid = []
var spawn_points = {}
func _ready() -> void:
	initialize_grid()

func initialize_grid():
	for x in range(grid_width):
		for y in range(grid_height):
			grid.append(Vector2i(x, y))
	
	for x in range(grid_width):
		spawn_points[x] = 0
