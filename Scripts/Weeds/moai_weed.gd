class_name MoaiWeed extends Weed

var type := Game_Enums.Weeds.MOAI
var current_cuts: int = 0
@export var cuts_needed: int = 3
var is_chiseled: bool = false

@onready var cracks: Sprite2D = $WeedMask/Cracks
@onready var chisel_sound: AudioStreamPlayer = $ChiselSound

@export var statue_texture: Texture

func _ready() -> void:
	super()
	cut_sound = chisel_sound
	cut_sound.stream = chisel_sound.stream
	if(weed_sprite.flip_h == true):
		cracks.flip_h = true
		
func cut():
	current_cuts += 1
	cracks.self_modulate.a = float(current_cuts)/float(cuts_needed)
	cut_sound.play()
	if(current_cuts>=cuts_needed):
		is_chiseled = true
		weed_sprite.texture = statue_texture
		cracks.self_modulate.a = 0
	if(current_cuts > cuts_needed):
		is_chiseled = true
		weed_sprite.texture = statue_texture
		super()

func fully_stretched():
	if(is_chiseled):
		check_kill(true)
	else:
		check_kill(false)
	super()
