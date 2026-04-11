class_name CornWeed extends Weed

var type := Game_Enums.Weeds.CORN
@export var inner_sprite: Texture
@export var outer_sprite: Texture
@onready var weed_sprite_outer: Sprite2D = $WeedMask/WeedSpriteOuter


var is_shucked: bool
func fully_stretched():
	if(stretched_vector.y > 0):
		is_shucked = true
		weed_sprite_outer.self_modulate.a = 0
	else:
		check_kill(false)
	super()

func cut():
	super()
	if(is_shucked):
		check_kill(true)
	else:
		check_kill(false)
