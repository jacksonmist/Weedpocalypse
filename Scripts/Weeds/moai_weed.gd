class_name MoaiWeed extends Weed

var current_cuts: int = 0
@export var cuts_needed: int = 3
var is_chiseled: bool = false

@export var statue_texture: Texture

func cut():
	current_cuts += 1
	if(current_cuts>=cuts_needed):
		super()
		check_kill(false)
		is_chiseled = true
		weed_sprite.texture = statue_texture

func fully_stretched():
	if(is_chiseled):
		check_kill(true)
	else:
		check_kill(false)
