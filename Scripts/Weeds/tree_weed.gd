class_name TreeWeed extends Weed

var type := Game_Enums.Weeds.TREE

@export var cuts_needed: int = 30
var current_cuts: int = 0

var tween_time: float = 0.1
var tilt: float = deg_to_rad(3)
@onready var tree_trunk_sound: AudioStreamPlayer = $TreeTrunkSound
@onready var tree_cracks: Sprite2D = $WeedMask/TreeCracks

func _ready() -> void:
	super()
	if(weed_sprite.flip_h == true):
		tree_cracks.flip_h = true

func cut():
	current_cuts += 1
	shake()
	tree_trunk_sound.play()
	tree_cracks.self_modulate.a = (float(current_cuts) / float(cuts_needed))
	if(current_cuts >= cuts_needed):
		super()
		check_kill(true)

func shake():
	var tween = create_tween()
	var direction_modifier = [-1, 1].pick_random()
	tween.tween_property(self, "rotation", tilt * direction_modifier, tween_time)
	tween.tween_property(self, "rotation", -tilt * direction_modifier, tween_time)
	tween.tween_property(self, "rotation", 0, tween_time)

func fully_stretched():
	super()
	check_kill(false)
