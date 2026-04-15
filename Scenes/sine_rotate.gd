extends Sprite2D
@export var time_offset: float
var time = 0
var speed: float = 1.5

func _ready() -> void:
	time += time_offset
	
func _process(delta: float) -> void:
	time += delta
	rotation = 0.75 * sin(time * speed)
