@abstract
class_name Weed extends Node2D

@export var sprite_array: Array[Texture]
const INITIAL_OFFSET: Vector2 = Vector2(0, 235)

@export var grow_rate: float = 50.0
var base_length = 240
var grow_rate_additive: float = 0.0
var growth: float = 0
var is_growing: bool = true
var is_grabbing: bool
var grab_point: Vector2
var initial_position: Vector2
var rotation_time: float = 0.5
var scale_time = 0.3
var stretch_threshold: float = 100

@onready var weed_mask: Sprite2D = $WeedMask
@onready var weed_sprite: Sprite2D = $WeedMask/WeedSprite
@onready var area_2d: Area2D = $Area2D
@onready var collision_shape: CollisionShape2D = $Area2D/CollisionShape2D
@onready var pivot: Node2D = get_parent()


func _ready() -> void:
	initial_position = position
	collision_shape.shape = collision_shape.shape.duplicate()
	weed_sprite.texture = sprite_array.pick_random()
	weed_mask.offset = INITIAL_OFFSET
	collision_shape.position = INITIAL_OFFSET

func _process(delta: float) -> void:
	if(weed_mask.offset.y > 0 and is_growing):
		growth += delta * grow_rate
		var offset = Vector2(0, INITIAL_OFFSET.y - growth)
		weed_mask.offset = offset
		collision_shape.position = offset
	elif(is_grabbing):
		var mouse_pos = get_global_mouse_position()
		var to_mouse = mouse_pos - pivot.position
		var distance_from_grab = (mouse_pos - grab_point).length()
		grow_rate_additive += (delta * grow_rate * 0.2)
		pivot.look_at(get_global_mouse_position())
		pivot.rotation += PI/2
		pivot.scale.y = to_mouse.length() / (base_length - weed_mask.offset.y)
		if(distance_from_grab > stretch_threshold):
			fully_stretched()
		
func return_to_normal():
	var tween = create_tween()
	tween.set_parallel()
	tween.set_trans(Tween.TRANS_ELASTIC)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(pivot, "scale", Vector2(1, 1), scale_time)
	tween.tween_property(pivot, "rotation", 0, rotation_time)
	
func grab(grabbing: bool):
	is_grabbing = grabbing
	if(is_grabbing):
		is_growing = false
		grab_point = get_global_mouse_position()
	else:
		is_growing = true
		grow_rate += grow_rate_additive
		grow_rate_additive = 0
		return_to_normal()
func fully_stretched():
	grab(false)

func cut():
	print("cutting")
	
func weedkiller():
	print("weed killering")
