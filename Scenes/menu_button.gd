extends TextureButton

@onready var button_label: RichTextLabel = $ButtonLabel
@onready var button_effect: Node = $ButtonEffect

@export var normal_text: String
@export var is_positive: bool
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	button_label.text = normal_text
	button_label.normal_text = normal_text
	button_label.is_positive = is_positive
	pressed.connect(play_click)

func change_text(new_text: String):
	normal_text = new_text
	button_label.normal_text = normal_text
	button_label.text = normal_text

func play_click():
	audio_stream_player.play()
