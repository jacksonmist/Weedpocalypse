extends Node

@onready var button: TextureButton = get_parent()

@export var trans_var: Tween.TransitionType
@export var ease_var: Tween.EaseType

@export var rotation: float = 3.0
@export var scale: float = 1.1
@export var tween_time = 0.07

var tween: Tween

func _ready() -> void:
	button.pivot_offset_ratio = Vector2(0.5, 0.5)
	button.mouse_entered.connect(_on_mouse_entered.bind(true))
	button.mouse_exited.connect(_on_mouse_entered.bind(false))

func _on_mouse_entered(hovered: bool):
	set_tween()
	
	tween.tween_property(button, "scale",
	 Vector2(scale, scale) if hovered else Vector2.ONE, tween_time)
	tween.tween_property(button, "rotation",
	 deg_to_rad(rotation) * [-1,1].pick_random() if hovered else 0.0, tween_time)
	
func set_tween():
	if(tween):
		tween.kill()
	tween = create_tween()
	tween.set_ease(ease_var).set_trans(trans_var).set_parallel()
