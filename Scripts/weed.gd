class_name Weed extends Node2D

@export var sprite_array: Array[Texture]
const INITIAL_OFFSET: Vector2 = Vector2(0, 235)

@export var grow_rate: float = 50
var growth: float = 0
@onready var weed_mask: Sprite2D = $WeedMask
@onready var weed_sprite: Sprite2D = $WeedMask/WeedSprite

func _ready() -> void:
	weed_sprite = sprite_array.pick_random()
	weed_mask.offset = INITIAL_OFFSET

func _process(delta: float) -> void:
	if(weed_mask.offset.y > 0):
		growth += delta * grow_rate
		weed_mask.offset = Vector2(0, INITIAL_OFFSET.y - growth)
