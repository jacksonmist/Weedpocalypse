class_name CornWeed extends Weed

@export var inner_sprite: Texture
var is_shucked: bool

func fully_stretched():
	if(stretched_vector.y > 0):
		is_shucked = true
		weed_sprite.texture = inner_sprite
	else:
		check_kill(false)
	super()

func cut():
	super()
	if(is_shucked):
		check_kill(true)
	else:
		check_kill(false)
