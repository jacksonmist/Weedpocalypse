extends TextureButton

@onready var button_label: RichTextLabel = $ButtonLabel
@onready var button_effect: Node = $ButtonEffect

@export var normal_text: String
@export var is_positive: bool
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	button_label.text = normal_text
	button_label.normal_text = normal_text
	button_label.is_positive = is_positive

func change_text(new_text: String):
	normal_text = new_text
	button_label.normal_text = normal_text
	button_label.text = normal_text
