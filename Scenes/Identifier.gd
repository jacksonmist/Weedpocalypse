extends TextureRect

@onready var weed_name: Label = $WeedName
var label_settings: LabelSettings
@onready var hint: Control = $Hint
var tween: Tween
var tween_time = 0.1
var transparent: Color = Color(1, 1, 1, 0)
var white: Color = Color(1, 1, 1, 1)


func _ready() -> void:
	mouse_entered.connect(_mouse_entered.bind(true))
	mouse_exited.connect(_mouse_entered.bind(false))
	label_settings = weed_name.label_settings.duplicate()
	weed_name.label_settings = label_settings
	hint.modulate.a = 0
	pivot_offset_ratio = Vector2(0.5, 0.5)

func _mouse_entered(hovered: bool):
	if(tween):
		tween.kill()
	tween = create_tween().set_trans(Tween.TRANS_SINE).set_parallel(true)
	if(hovered):
		tween.tween_property(self, "scale", Vector2(1.1, 1.1), tween_time)
		tween.tween_property(weed_name, "modulate", transparent, tween_time)
		tween.set_parallel(false)
		tween.tween_property(hint, "modulate", white, tween_time)
	else:
		tween.tween_property(self, "scale", Vector2(1,1), tween_time)
		tween.tween_property(hint, "modulate", transparent, tween_time)
		tween.set_parallel(false)
		tween.tween_property(weed_name, "modulate", white, tween_time)
