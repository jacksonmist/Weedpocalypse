extends RichTextLabel

@onready var button: TextureButton = get_parent()

@export var normal_text: String
@export var is_positive: bool
@export var base_color: Color
@export var outline_color: Color

var pos_effect_prefix: String = "[rainbow freq=1.0 sat=0.8 val=0.8 speed=1.0]"
var pos_effect_postfix: String = "[/rainbow]"

var neg_effect_prefix: String = "[pulse freq=1.0 color=#ff957e ease=-2.0]"
var neg_effect_postfix: String = "[/pulse]"

var prefix
var postfix
func _ready() -> void:
	
	button.mouse_entered.connect(_on_mouse_entered.bind(true))
	button.mouse_exited.connect(_on_mouse_entered.bind(false))

func _on_mouse_entered(hovered: bool):
	if(is_positive):
		prefix = pos_effect_prefix
		postfix = pos_effect_postfix
	else:
		prefix = neg_effect_prefix
		postfix = neg_effect_postfix
	if(hovered):
		text = prefix + normal_text + postfix
	else:
		text = normal_text
