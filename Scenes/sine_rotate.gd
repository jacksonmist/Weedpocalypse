extends Sprite2D
var time = 0
var speed: float = 1.5

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time += delta
	rotation = 0.75 * sin(time * speed)
